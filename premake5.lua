require "vendor/premake/export-compile-commands"

workspace "easy-ui"
    architecture "x64"

    configurations {
        "Debug",
        "Release"
    }

outputdir = "%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}"

project "EasyUI"
    location "EasyUI"
    kind "SharedLib"
    language "C++"
    cppdialect "C++20"

    targetdir ("bin/" .. outputdir .. "/%{prj.name}")
    objdir ("bin-int/" .. outputdir .. "/%{prj.name}")

    files {
        "%{prj.name}/src/**.h",
        "%{prj.name}/src/**.cpp"
    }

    includedirs {
        "%{prj.name}/src"
    }

    filter "configurations:Debug"
        defines { "EASYUI_DEBUG" }
        symbols "On"

    filter "configurations:Release"
        defines { "EASYUI_RELEASE" }
        optimize "On"

    postbuildcommands {
        -- in case cp interprets /Sandbox as the target file and not the target directory
        ("{MKDIR} ../bin/" .. outputdir .. "/Sandbox"),
        ("{COPYFILE} %{cfg.buildtarget.relpath} ../bin/" .. outputdir .. "/Sandbox")
    }

project "Sandbox"
    location "Sandbox"
    kind "ConsoleApp"
    language "C++"
    cppdialect "C++20"

    targetdir ("bin/" .. outputdir .. "/%{prj.name}")
    objdir ("bin-int/" .. outputdir .. "/%{prj.name}")

    files {
        "%{prj.name}/src/**.h",
        "%{prj.name}/src/**.cpp"
    }

    includedirs {
        "EasyUI/src"
    }

    links {
        "EasyUI"
    }

    filter "configurations:Debug"
        defines { "EASYUI_DEBUG" }
        symbols "On"

    filter "configurations:Release"
        defines { "EASYUI_RELEASE" }
        optimize "On"