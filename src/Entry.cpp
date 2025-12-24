#include "Entry.h"
#include "SDK/api/sapphire/IMod.h"
#include "SDK/api/sapphire/logger/Logger.h"

namespace my_mod {

    SPHR_REGISTRY_MOD(MyMod)

    sapphire::Logger log{"MyMod"};

    void MyMod::onLoaded() {
        log.info("MyMod::onLoaded");
    }

    void MyMod::onUnload() {
        log.info("MyMod::onUnload");
    }

    void MyMod::onInit(const sapphire::ModInitContext &context) {
        log.info("MyMod::onInit");
    }

    void MyMod::onUnInit() {
        log.info("MyMod::onUnInit");
    }

} // namespace my_mod