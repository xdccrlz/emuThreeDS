//
//  CoreWrapper.m
//  emuThreeDS
//
//  Created by Antique on 27/3/2023.
//

#import "CoreWrapper.h"


#include <iostream>
#include <memory>
#include <regex>
#include <string>
#include <thread>
// This needs to be included before getopt.h because the latter #defines symbols used by it
#include "citra/emu_window/emu_window_vk.hpp"
#include "citra/config.h"
#include "common/common_paths.h"
#include "common/detached_tasks.h"
#include "common/file_util.h"
#include "common/logging/backend.h"
#include "common/logging/log.h"
#include "common/microprofile.h"
#include "common/scope_exit.h"
#include "common/settings.h"
#include "common/string_util.h"
#include "core/core.h"
#include "core/dumping/backend.h"
#include "core/frontend/applets/default_applets.h"
#include "core/frontend/framebuffer_layout.h"
#include "core/hle/service/am/am.h"
#include "core/hle/service/nfc/nfc.h"
#include "core/hle/service/cfg/cfg.h"
#include "core/movie.h"
#include "input_common/main.h"



#include <cstring>
#include <map>
#include <memory>
#include <vector>

#include "common/string_util.h"
#include "core/hle/service/am/am.h"
#include "core/hle/service/fs/archive.h"
#include "core/loader/loader.h"
#include "core/loader/smdh.h"

namespace GameInfo {

std::vector<u8> GetSMDHData(std::string physical_name) {
    std::unique_ptr<Loader::AppLoader> loader = Loader::GetLoader(physical_name);
    if (!loader) {
        return {};
    }

    u64 program_id = 0;
    loader->ReadProgramId(program_id);

    std::vector<u8> smdh = [program_id, &loader]() -> std::vector<u8> {
        std::vector<u8> original_smdh;
        loader->ReadIcon(original_smdh);

        if (program_id < 0x00040000'00000000 || program_id > 0x00040000'FFFFFFFF)
            return original_smdh;

        std::string update_path = Service::AM::GetTitleContentPath(
            Service::FS::MediaType::SDMC, program_id + 0x0000000E'00000000);

        if (!FileUtil::Exists(update_path))
            return original_smdh;

        std::unique_ptr<Loader::AppLoader> update_loader = Loader::GetLoader(update_path);

        if (!update_loader)
            return original_smdh;

        std::vector<u8> update_smdh;
        update_loader->ReadIcon(update_smdh);
        return update_smdh;
    }();

    return smdh;
}

std::u16string GetTitle(std::string physical_name) {
    Loader::SMDH::TitleLanguage language = Loader::SMDH::TitleLanguage::English;
    std::vector<u8> smdh_data = GetSMDHData(physical_name);

    if (!Loader::IsValidSMDH(smdh_data)) {
        // SMDH is not valid, return null
        return {};
    }

    Loader::SMDH smdh;
    memcpy(&smdh, smdh_data.data(), sizeof(Loader::SMDH));

    // Get the title from SMDH in UTF-16 format
    std::u16string title{
        reinterpret_cast<char16_t*>(smdh.titles[static_cast<int>(language)].long_title.data())};

    return title;
}

std::u16string GetPublisher(std::string physical_name) {
    Loader::SMDH::TitleLanguage language = Loader::SMDH::TitleLanguage::English;
    std::vector<u8> smdh_data = GetSMDHData(physical_name);

    if (!Loader::IsValidSMDH(smdh_data)) {
        // SMDH is not valid, return null
        return {};
    }

    Loader::SMDH smdh;
    memcpy(&smdh, smdh_data.data(), sizeof(Loader::SMDH));

    // Get the Publisher's name from SMDH in UTF-16 format
    char16_t* publisher;
    publisher =
        reinterpret_cast<char16_t*>(smdh.titles[static_cast<int>(language)].publisher.data());

    return publisher;
}

std::string GetRegions(std::string physical_name) {
    std::vector<u8> smdh_data = GetSMDHData(physical_name);

    if (!Loader::IsValidSMDH(smdh_data)) {
        // SMDH is not valid, return "Invalid region"
        return "Invalid region";
    }

    Loader::SMDH smdh;
    memcpy(&smdh, smdh_data.data(), sizeof(Loader::SMDH));

    using GameRegion = Loader::SMDH::GameRegion;
    static const std::map<GameRegion, const char*> regions_map = {
        {GameRegion::Japan, "Japan"},   {GameRegion::NorthAmerica, "North America"},
        {GameRegion::Europe, "Europe"}, {GameRegion::Australia, "Australia"},
        {GameRegion::China, "China"},   {GameRegion::Korea, "Korea"},
        {GameRegion::Taiwan, "Taiwan"}};
    std::vector<GameRegion> regions = smdh.GetRegions();

    if (regions.empty()) {
        return "Invalid region";
    }

    const bool region_free =
        std::all_of(regions_map.begin(), regions_map.end(), [&regions](const auto& it) {
            return std::find(regions.begin(), regions.end(), it.first) != regions.end();
        });

    if (region_free) {
        return "Region free";
    }

    const std::string separator = ", ";
    std::string result = regions_map.at(regions.front());
    for (auto region = ++regions.begin(); region != regions.end(); ++region) {
        result += separator + regions_map.at(*region);
    }

    return result;
}

std::vector<u16> GetIcon(std::string physical_name) {
    std::vector<u8> smdh_data = GetSMDHData(physical_name);

    if (!Loader::IsValidSMDH(smdh_data)) {
        // SMDH is not valid, return null
        return std::vector<u16>(0, 0);
    }

    Loader::SMDH smdh;
    memcpy(&smdh, smdh_data.data(), sizeof(Loader::SMDH));

    // Always get a 48x48(large) icon
    std::vector<u16> icon_data = smdh.GetIcon(true);
    return icon_data;
}

}


/*
 
 jboolean Java_org_citra_citra_1emu_NativeLibrary_LoadAmiibo(JNIEnv* env, jclass clazz,
                                                             jbyteArray bytes) {
     Core::System& system{Core::System::GetInstance()};
     Service::SM::ServiceManager& sm = system.ServiceManager();
     auto nfc = sm.GetService<Service::NFC::Module::Interface>("nfc:u");
     if (nfc == nullptr || env->GetArrayLength(bytes) != sizeof(Service::NFC::AmiiboData)) {
         return static_cast<jboolean>(false);
     }

     Service::NFC::AmiiboData amiibo_data{};
     env->GetByteArrayRegion(bytes, 0, sizeof(Service::NFC::AmiiboData),
                             reinterpret_cast<jbyte*>(&amiibo_data));

     nfc->LoadAmiibo(amiibo_data);
     return static_cast<jboolean>(true);
 }

 void Java_org_citra_citra_1emu_NativeLibrary_RemoveAmiibo(JNIEnv* env, jclass clazz) {
     Core::System& system{Core::System::GetInstance()};
     Service::SM::ServiceManager& sm = system.ServiceManager();
     auto nfc = sm.GetService<Service::NFC::Module::Interface>("nfc:u");
     if (nfc == nullptr) {
         return;
     }

     nfc->RemoveAmiibo();
 }
 
 */





Core::System& core{Core::System::GetInstance()};
std::unique_ptr<EmuWindow_VK> _topEmuWindow;


static void InitializeLogging() {
    Log::Filter log_filter(Log::Level::Debug);
    log_filter.ParseFilterString(Settings::values.log_filter.GetValue());
    Log::SetGlobalFilter(log_filter);

    Log::AddBackend(std::make_unique<Log::ColorConsoleBackend>());

    const std::string& log_dir = FileUtil::GetUserPath(FileUtil::UserPath::LogDir);
    FileUtil::CreateFullPath(log_dir);
    Log::AddBackend(std::make_unique<Log::FileBackend>(log_dir + LOG_FILE));
}


#define SDL_MAIN_HANDLED
#include <SDL2/SDL.h>

#include "ButtonInputBridge.h"
#include "emuThreeDS-Swift.h"
@class EmulatorInput;
@class GeneralController;
class AnalogFactory : public Input::Factory<Input::AnalogDevice> {
    std::unique_ptr<Input::AnalogDevice> Create(const Common::ParamPackage& params) override {
        int button_id = params.Get("code", 0);
        AnalogInputBridge* emuInput = nullptr;
        switch ((Settings::NativeAnalog::Values)button_id) {
            case Settings::NativeAnalog::CirclePad:
                emuInput = EmulatorInput.circlePad;
                break;
            case Settings::NativeAnalog::CStick:
                emuInput = EmulatorInput.circlePadPro;
                break;
            case Settings::NativeAnalog::NumAnalogs:
                UNREACHABLE();
                break;
        }
        if (emuInput == nullptr) {
            return {};
        }
        AnalogBridge* ib = [emuInput getCppBridge];
        return std::unique_ptr<AnalogBridge>(ib);
    };
};

class ButtonFactory : public Input::Factory<Input::ButtonDevice> {
    std::unique_ptr<Input::ButtonDevice> Create(const Common::ParamPackage& params) override {
            int button_id = params.Get("code", 0);
            ButtonInputBridge* emuInput = nullptr;
            switch ((Settings::NativeButton::Values)button_id) {
                case Settings::NativeButton::A:
                    emuInput = EmulatorInput.buttonA;
                    break;
                case Settings::NativeButton::B:
                    emuInput = EmulatorInput.buttonB;
                    break;
                case Settings::NativeButton::X:
                    emuInput = EmulatorInput.buttonX;
                    break;
                case Settings::NativeButton::Y:
                    emuInput = EmulatorInput.buttonY;
                    break;
                case Settings::NativeButton::Up:
                    emuInput = EmulatorInput.dpadUp;
                    break;
                case Settings::NativeButton::Down:
                    emuInput = EmulatorInput.dpadDown;
                    break;
                case Settings::NativeButton::Left:
                    emuInput = EmulatorInput.dpadLeft;
                    break;
                case Settings::NativeButton::Right:
                    emuInput = EmulatorInput.dpadRight;
                    break;
                case Settings::NativeButton::L:
                    emuInput = EmulatorInput.buttonL;
                    break;
                case Settings::NativeButton::R:
                    emuInput = EmulatorInput.buttonR;
                    break;
                case Settings::NativeButton::Start:
                    emuInput = EmulatorInput.buttonStart;
                    break;
                case Settings::NativeButton::Select:
                    emuInput = EmulatorInput.buttonSelect;
                    break;
                case Settings::NativeButton::ZL:
                    emuInput = EmulatorInput.buttonZL;
                    break;
                case Settings::NativeButton::ZR:
                    emuInput = EmulatorInput.buttonZR;
                    break;
                case Settings::NativeButton::Debug:
                case Settings::NativeButton::Gpio14:
                case Settings::NativeButton::Home:
                case Settings::NativeButton::NumButtons:
                    emuInput = EmulatorInput._buttonDummy;
            }
            if (emuInput == nullptr) {
                return {};
            }
            ButtonBridge<bool>* ib = [emuInput getCppBridge];
            return std::unique_ptr<ButtonBridge<bool>>(ib);
        };
};


@implementation SaveState
-(id) initWith:(uint32_t)slot time:(uint64_t)time status:(ValidationStatus)status {
    if (self = [super init]) {
        self.slot = slot;
        self.time = time;
        self.status = status;
    } return self;
}
@end


#include "filehandle.h"
@implementation CoreWrapper
- (instancetype)init {
    if (self = [super init]) {
        // InitializeLogging();
    } return self;
}

-(void) insertRom:(NSString *)path layer:(CAMetalLayer *)layer {
    Config{};
    for (int i = 0; i < Settings::NativeButton::NumButtons; i++) {
        Common::ParamPackage param{
            {"engine", "ios_gamepad"},
            {"code", std::to_string(i)},
        };
        Settings::values.current_input_profile.buttons[i] = param.Serialize();
    }
    
    for (int i = 0; i < Settings::NativeAnalog::NumAnalogs; i++) {
        Common::ParamPackage param{
            {"engine", "ios_gamepad"},
            {"code", std::to_string(i)},
        };
        Settings::values.current_input_profile.analogs[i] = param.Serialize();
    }
    
    GeneralController* generalController = [[GeneralController alloc] init];
    Settings::values.use_cpu_jit.SetValue([generalController containsWithIdentifier:@"use_jit"]);
    Settings::values.use_hle = [generalController containsWithIdentifier:@"use_hle"];
    Settings::values.layout_option.SetValue(Settings::LayoutOption::SideScreen);
    
    
    Settings::Apply();
    Settings::LogSettings();
    
    Input::RegisterFactory<Input::ButtonDevice>("ios_gamepad", std::make_shared<ButtonFactory>());
    Input::RegisterFactory<Input::AnalogDevice>("ios_gamepad", std::make_shared<AnalogFactory>());
    
    _topEmuWindow = std::make_unique<EmuWindow_VK>((__bridge CA::MetalLayer *)layer);
    _topEmuWindow->MakeCurrent();
    
    core.Load(*_topEmuWindow, [path cStringUsingEncoding:NSUTF8StringEncoding]);
    while (_run)
        core.RunLoop();
}


-(void) touch:(CGPoint)point {
    _topEmuWindow->TouchPressed((point.x + 0.5) * 2, point.y + 0.5);
    _topEmuWindow->TouchReleased();
}



-(void) installCIA:(NSString *)path withCompletion:(void (^)(NSString *path))completionHandler {
    const auto cia_progress = [](std::size_t written, std::size_t total) {
        LOG_INFO(Frontend, "{:02d}%", (written * 100 / total));
    };
    
    Service::AM::InstallStatus status = Service::AM::InstallCIA([path cStringUsingEncoding:NSUTF8StringEncoding], cia_progress);
    switch (status) {
        case Service::AM::InstallStatus::Success:
            completionHandler(path);
        default:
            LOG_ERROR(Service_AM, "Failed CIA install");
            break;
    }
}

-(NSMutableArray<NSString *> *) installedGamePaths {
    NSMutableArray<NSString *> *games = @[].mutableCopy;
    const FileUtil::DirectoryEntryCallable ScanDir = [&games, &ScanDir](u64*, const std::string& directory, const std::string& virtual_name) {
        std::string path = directory + virtual_name;
        if (FileUtil::IsDirectory(path)) {
            path += '/';
            FileUtil::ForeachDirectoryEntry(nullptr, path, ScanDir);
        } else {
            if (!FileUtil::Exists(path))
                return false;
            auto loader = Loader::GetLoader(path);
            if (loader) {
                bool executable{};
                const Loader::ResultStatus result = loader->IsExecutable(executable);
                if (Loader::ResultStatus::Success == result && executable) {
                    [games addObject:[NSString stringWithCString:path.c_str() encoding:NSUTF8StringEncoding]];
                }
            }
        } return true;
    };
    
    
    ScanDir(nullptr, "", FileUtil::GetUserPath(FileUtil::UserPath::SDMCDir) + "Nintendo " "3DS/00000000000000000000000000000000/" "00000000000000000000000000000000/title/00040000");
    ScanDir(nullptr, "", FileUtil::GetUserPath(FileUtil::UserPath::NANDDir) + "00000000000000000000000000000000/title/00040010");
    return games;
}


-(void) GameIcon:(NSString *)path completion:(void (^)(uint16_t *bitmapData))completionHandler {
    std::vector<u16> icon = GameInfo::GetIcon([path cStringUsingEncoding:NSUTF8StringEncoding]);
    uint16_t* data;
    memcpy(data, icon.data(), 0x1200);
    completionHandler(data);
}

-(NSString *) GameTitle:(NSString *)path {
    std::u16string string = GameInfo::GetTitle(std::string([path UTF8String]));
    return [NSString stringWithCharacters:(const unichar *)string.c_str() length:string.size()];
}

-(NSMutableArray<SaveState *> *) ListSaveStates {
    if (!core.IsPoweredOn())
        return @[].mutableCopy;
    
    uint64_t title_id;
    if (core.GetAppLoader().ReadProgramId(title_id) != Loader::ResultStatus::Success)
        return @[].mutableCopy;
    
    NSMutableArray *saves = @[].mutableCopy;
    std::vector<Core::SaveStateInfo> allSaves = Core::ListSaveStates(title_id);
    for (int i = 0; i < allSaves.size(); i++) {
        SaveState *save = [[SaveState alloc] initWith:allSaves[i].slot time:allSaves[i].time status:(ValidationStatus)allSaves[i].status];
        [saves addObject:save];
    }
    
    return saves;
}

-(bool) SaveState {
    return core.SendSignal(Core::System::Signal::Save, [self ListSaveStates].count + 1);
}

-(void) LoadState:(SaveState *)state {
    NSLog(@"%@", state);
    core.SendSignal(Core::System::Signal::Load, state.slot);
}


-(bool) InsertAmiibo:(NSString *)path {
    Service::SM::ServiceManager& sm = core.ServiceManager();
    auto nfc = sm.GetService<Service::NFC::Module::Interface>("nfc:u");
    
    NSData *data = [NSData dataWithContentsOfFile:path];
    if (nfc == nullptr || data.length != sizeof(Service::NFC::AmiiboData)) {
        return false;
    }

    Service::NFC::AmiiboData amiibo_data{};
    std::memcpy(&amiibo_data, data.bytes, sizeof(Service::NFC::AmiiboData));

    nfc->LoadAmiibo(amiibo_data);
    return true;
}

-(void) RemoveAmiibo {
    Service::SM::ServiceManager& sm = core.ServiceManager();
    auto nfc = sm.GetService<Service::NFC::Module::Interface>("nfc:u");
    if (nfc == nullptr) {
        return;
    }

    nfc->RemoveAmiibo();
}

-(NSMutableArray<NSString *> *) ListAmiibos {
    NSURL *amiibosDirectoryURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask][0] URLByAppendingPathComponent:@"amiibos"];
    NSArray<NSString *> *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[amiibosDirectoryURL path] error:nil];
    
    NSMutableArray<NSString *> *amiibosPaths = @[].mutableCopy;
    [contents enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [amiibosPaths addObject:[[amiibosDirectoryURL URLByAppendingPathComponent:obj] path]];
    }];
    
    return amiibosPaths;
}
@end
