const std = @import("std");

const Path = std.Build.LazyPath;

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    //1. External interface to build using 'zig build -Doption=value'
    const linkage = b.option(std.builtin.LinkMode, "linkage", "Build shared library or static library") orelse .static;

    // 2. Option to pass when library is used as dependency
    // https://ziglang.org/documentation/master/std/#std.Build.addOptions
    const options = b.addOptions();
    options.addOption(std.builtin.LinkMode, "linkage", linkage);

    const root_module_opts: std.Build.Module.CreateOptions = .{
        .root_source_file = null,
        .target = target,
        .optimize = optimize,
        .link_libc = true,
        .link_libcpp = true,
    };

    const screen = b.addLibrary(.{
        .linkage = linkage,
        .name = "screen",
        .root_module = b.createModule(root_module_opts),
    });

    screen.addIncludePath(b.path("include"));
    screen.addIncludePath(b.path("src"));
    screen.addCSourceFiles(.{
        .files = &.{
            "src/ftxui/screen/box.cpp",
            "src/ftxui/screen/color_info.cpp",
            //"src/ftxui/screen/color_test.cpp",
            "src/ftxui/screen/color.cpp",
            "src/ftxui/screen/image.cpp",
            "src/ftxui/screen/screen.cpp",
            //"src/ftxui/screen/string_test.cpp",
            "src/ftxui/screen/string.cpp",
            "src/ftxui/screen/terminal.cpp",
        },
        .flags = &.{
            "-std=c++17",
            // "-fno-rtti",
            "-frtti",
            // "-fno-exceptions",
            "-fexceptions",
            "-DFTXUI_BUILD_TESTS=OFF",
        },
    });
    screen.installHeadersDirectory(b.path("include"), "", .{
        .include_extensions = &.{
            ".hpp",
        },
        .exclude_extensions = &.{
            "am",
            "gitignore",
        },
    });

    b.installArtifact(screen);

    const dom = b.addLibrary(.{
        .linkage = linkage,
        .name = "dom",
        .root_module = b.createModule(root_module_opts),
    });
    dom.addIncludePath(b.path("include"));
    dom.addIncludePath(b.path("src"));
    dom.addCSourceFiles(.{
        .files = &.{
            "src/ftxui/dom/automerge.cpp",
            "src/ftxui/dom/blink.cpp",
            "src/ftxui/dom/bold.cpp",
            "src/ftxui/dom/hyperlink.cpp",
            "src/ftxui/dom/border.cpp",
            "src/ftxui/dom/box_helper.cpp",
            "src/ftxui/dom/canvas.cpp",
            "src/ftxui/dom/clear_under.cpp",
            "src/ftxui/dom/color.cpp",
            "src/ftxui/dom/composite_decorator.cpp",
            "src/ftxui/dom/dbox.cpp",
            "src/ftxui/dom/dim.cpp",
            "src/ftxui/dom/flex.cpp",
            "src/ftxui/dom/flexbox.cpp",
            "src/ftxui/dom/flexbox_config.cpp",
            "src/ftxui/dom/flexbox_helper.cpp",
            "src/ftxui/dom/focus.cpp",
            "src/ftxui/dom/frame.cpp",
            "src/ftxui/dom/gauge.cpp",
            "src/ftxui/dom/graph.cpp",
            "src/ftxui/dom/gridbox.cpp",
            "src/ftxui/dom/hbox.cpp",
            "src/ftxui/dom/inverted.cpp",
            "src/ftxui/dom/linear_gradient.cpp",
            "src/ftxui/dom/node.cpp",
            "src/ftxui/dom/node_decorator.cpp",
            "src/ftxui/dom/paragraph.cpp",
            "src/ftxui/dom/reflect.cpp",
            "src/ftxui/dom/scroll_indicator.cpp",
            "src/ftxui/dom/separator.cpp",
            "src/ftxui/dom/size.cpp",
            "src/ftxui/dom/spinner.cpp",
            "src/ftxui/dom/strikethrough.cpp",
            "src/ftxui/dom/table.cpp",
            "src/ftxui/dom/text.cpp",
            "src/ftxui/dom/underlined.cpp",
            "src/ftxui/dom/underlined_double.cpp",
            "src/ftxui/dom/util.cpp",
            "src/ftxui/dom/selection.cpp",
            "src/ftxui/dom/selection_style.cpp",
            // "src/ftxui/dom/selection_test.cpp",
            "src/ftxui/dom/vbox.cpp",
        },
        .flags = &.{
            "-std=c++17",
            "-frtti",
            "-fexceptions",
        },
    });
    dom.installHeadersDirectory(b.path("include"), "", .{
        .include_extensions = &.{
            ".hpp",
        },
        .exclude_extensions = &.{
            "am",
            "gitignore",
        },
    });
    dom.linkLibrary(screen);
    b.installArtifact(dom);

    const component = b.addLibrary(.{
        .linkage = linkage,
        .name = "component",
        .root_module = b.createModule(root_module_opts),
    });
    component.addIncludePath(b.path("include"));
    component.addIncludePath(b.path("src"));
    component.addCSourceFiles(.{ .files = &.{
        "src/ftxui/component/animation.cpp",
        "src/ftxui/component/button.cpp",
        "src/ftxui/component/catch_event.cpp",
        "src/ftxui/component/checkbox.cpp",
        "src/ftxui/component/collapsible.cpp",
        "src/ftxui/component/component.cpp",
        "src/ftxui/component/component_options.cpp",
        "src/ftxui/component/container.cpp",
        "src/ftxui/component/dropdown.cpp",
        "src/ftxui/component/event.cpp",
        "src/ftxui/component/hoverable.cpp",
        "src/ftxui/component/input.cpp",
        "src/ftxui/component/loop.cpp",
        "src/ftxui/component/maybe.cpp",
        "src/ftxui/component/menu.cpp",
        "src/ftxui/component/modal.cpp",
        "src/ftxui/component/radiobox.cpp",
        "src/ftxui/component/renderer.cpp",
        "src/ftxui/component/resizable_split.cpp",
        "src/ftxui/component/screen_interactive.cpp",
        "src/ftxui/component/slider.cpp",
        "src/ftxui/component/terminal_input_parser.cpp",
        "src/ftxui/component/util.cpp",
        "src/ftxui/component/window.cpp",
    }, .flags = &.{ "-std=c++17", "-frtti", "-fexceptions", "-DUNICODE" } });
    component.installHeadersDirectory(b.path("include"), "", .{
        .include_extensions = &.{
            ".hpp",
        },
        .exclude_extensions = &.{
            "am",
            "gitignore",
        },
    });
    component.linkLibrary(dom);
    b.installArtifact(component);
}
