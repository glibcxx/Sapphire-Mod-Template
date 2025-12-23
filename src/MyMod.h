#pragma once

#include "SDK/api/sapphire/IMod.h"

namespace my_mod {

    class MyMod : public sapphire::IMod {
    public:
        virtual void onLoaded() override;

        virtual void onUnload() override;

        virtual void onInit(const sapphire::ModInitContext &context) override;

        virtual void onUnInit() override;
    };

} // namespace my_mod