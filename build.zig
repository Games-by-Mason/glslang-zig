const std = @import("std");

const flags: []const []const u8 = &.{
    "-std=c++17",
    "-fno-exceptions",
    "-fno-rtti",
};

pub fn build(b: *std.Build) !void {
    // Config
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const enable_opt = b.option(bool, "enable-opt", "Enables spirv-opt capability if present") orelse true;

    // Upstream Sources
    const spirv_tools_upstream = b.dependency("SPIRV-Tools", .{});
    const glslang_upstream = b.dependency("glslang", .{});

    // libspirv-tools
    const spirv_tools_static = b.addStaticLibrary(.{
        .name = "SPIRV-Tools",
        .target = target,
        .optimize = optimize,
    });
    const spirv_tools_shared = b.addSharedLibrary(.{
        .name = "SPIRV-Tools-shared",
        .target = target,
        .optimize = optimize,
    });
    const spirv_tools_builds = [_]*std.Build.Step.Compile{ spirv_tools_static, spirv_tools_shared };
    for (spirv_tools_builds) |spirv_tools_build| {
        spirv_tools_build.linkLibCpp();
        configureSpirvToolsLibrary(spirv_tools_build);
        spirv_tools_build.addCSourceFiles(.{
            .root = spirv_tools_upstream.path("source"),
            .files = &.{
                "assembly_grammar.cpp",
                "binary.cpp",
                "diagnostic.cpp",
                "disassemble.cpp",
                "enum_string_mapping.cpp",
                "ext_inst.cpp",
                "extensions.cpp",
                "libspirv.cpp",
                "name_mapper.cpp",
                "opcode.cpp",
                "operand.cpp",
                "parsed_operand.cpp",
                "pch_source.cpp",
                "print.cpp",
                "software_version.cpp",
                "spirv_endian.cpp",
                "spirv_fuzzer_options.cpp",
                "spirv_optimizer_options.cpp",
                "spirv_reducer_options.cpp",
                "spirv_target_env.cpp",
                "spirv_validator_options.cpp",
                "table.cpp",
                "text.cpp",
                "text_handler.cpp",
                "util/bit_vector.cpp",
                "util/parse_number.cpp",
                "util/string_utils.cpp",
                "util/timer.cpp",
                "val/basic_block.cpp",
                "val/construct.cpp",
                "val/function.cpp",
                "val/instruction.cpp",
                "val/validate.cpp",
                "val/validate_adjacency.cpp",
                "val/validate_annotation.cpp",
                "val/validate_arithmetics.cpp",
                "val/validate_atomics.cpp",
                "val/validate_barriers.cpp",
                "val/validate_bitwise.cpp",
                "val/validate_builtins.cpp",
                "val/validate_capability.cpp",
                "val/validate_cfg.cpp",
                "val/validate_composites.cpp",
                "val/validate_constants.cpp",
                "val/validate_conversion.cpp",
                "val/validate_debug.cpp",
                "val/validate_decorations.cpp",
                "val/validate_derivatives.cpp",
                "val/validate_execution_limitations.cpp",
                "val/validate_extensions.cpp",
                "val/validate_function.cpp",
                "val/validate_id.cpp",
                "val/validate_image.cpp",
                "val/validate_instruction.cpp",
                "val/validate_interfaces.cpp",
                "val/validate_layout.cpp",
                "val/validate_literals.cpp",
                "val/validate_logicals.cpp",
                "val/validate_memory.cpp",
                "val/validate_memory_semantics.cpp",
                "val/validate_mesh_shading.cpp",
                "val/validate_misc.cpp",
                "val/validate_mode_setting.cpp",
                "val/validate_non_uniform.cpp",
                "val/validate_primitives.cpp",
                "val/validate_ray_query.cpp",
                "val/validate_ray_tracing.cpp",
                "val/validate_ray_tracing_reorder.cpp",
                "val/validate_scopes.cpp",
                "val/validate_small_type_uses.cpp",
                "val/validate_type.cpp",
                "val/validation_state.cpp",
            },
            .flags = flags,
        });
        b.installArtifact(spirv_tools_build);
    }

    // libSPIRV-Tools-diff
    const spirv_tools_diff_static = b.addStaticLibrary(.{
        .name = "SPIRV-Tools-diff",
        .target = target,
        .optimize = optimize,
    });
    spirv_tools_diff_static.linkLibCpp();
    configureSpirvToolsLibrary(spirv_tools_diff_static);
    spirv_tools_diff_static.addCSourceFiles(.{
        .root = spirv_tools_upstream.path("source/diff"),
        .files = &.{"diff.cpp"},
        .flags = flags,
    });
    b.installArtifact(spirv_tools_diff_static);

    // libSPIRV-Tools-link
    const spirv_tools_link_static = b.addStaticLibrary(.{
        .name = "SPIRV-Tools-link",
        .target = target,
        .optimize = optimize,
    });
    spirv_tools_link_static.linkLibCpp();
    configureSpirvToolsLibrary(spirv_tools_link_static);
    spirv_tools_link_static.addCSourceFiles(.{
        .root = spirv_tools_upstream.path("source/link"),
        .files = &.{"linker.cpp"},
        .flags = flags,
    });
    b.installArtifact(spirv_tools_link_static);

    // libSPIRV-Tools-lint
    const spirv_tools_lint_static = b.addStaticLibrary(.{
        .name = "SPIRV-Tools-lint",
        .target = target,
        .optimize = optimize,
    });
    spirv_tools_lint_static.linkLibCpp();
    configureSpirvToolsLibrary(spirv_tools_lint_static);
    spirv_tools_lint_static.addCSourceFiles(.{
        .root = spirv_tools_upstream.path("source/lint"),
        .files = &.{
            "divergence_analysis.cpp",
            "lint_divergent_derivatives.cpp",
            "linter.cpp",
        },
        .flags = flags,
    });
    b.installArtifact(spirv_tools_lint_static);

    // libSPIRC-Tools-opt
    const spirv_tools_opt_static = b.addStaticLibrary(.{
        .name = "SPIRV-Tools-opt",
        .target = target,
        .optimize = optimize,
    });
    spirv_tools_opt_static.linkLibCpp();
    configureSpirvToolsLibrary(spirv_tools_opt_static);
    spirv_tools_opt_static.addCSourceFiles(.{
        .root = spirv_tools_upstream.path("source/opt"),
        .files = &.{
            "aggressive_dead_code_elim_pass.cpp",
            "amd_ext_to_khr.cpp",
            "analyze_live_input_pass.cpp",
            "basic_block.cpp",
            "block_merge_pass.cpp",
            "block_merge_util.cpp",
            "build_module.cpp",
            "ccp_pass.cpp",
            "cfg.cpp",
            "cfg_cleanup_pass.cpp",
            "code_sink.cpp",
            "combine_access_chains.cpp",
            "compact_ids_pass.cpp",
            "composite.cpp",
            "const_folding_rules.cpp",
            "constants.cpp",
            "control_dependence.cpp",
            "convert_to_half_pass.cpp",
            "convert_to_sampled_image_pass.cpp",
            "copy_prop_arrays.cpp",
            "dataflow.cpp",
            "dead_branch_elim_pass.cpp",
            "dead_insert_elim_pass.cpp",
            "dead_variable_elimination.cpp",
            "debug_info_manager.cpp",
            "decoration_manager.cpp",
            "def_use_manager.cpp",
            "desc_sroa.cpp",
            "desc_sroa_util.cpp",
            "dominator_analysis.cpp",
            "dominator_tree.cpp",
            "eliminate_dead_constant_pass.cpp",
            "eliminate_dead_functions_pass.cpp",
            "eliminate_dead_functions_util.cpp",
            "eliminate_dead_io_components_pass.cpp",
            "eliminate_dead_members_pass.cpp",
            "eliminate_dead_output_stores_pass.cpp",
            "feature_manager.cpp",
            "fix_func_call_arguments.cpp",
            "fix_storage_class.cpp",
            "flatten_decoration_pass.cpp",
            "fold.cpp",
            "fold_spec_constant_op_and_composite_pass.cpp",
            "folding_rules.cpp",
            "freeze_spec_constant_value_pass.cpp",
            "function.cpp",
            "graphics_robust_access_pass.cpp",
            "if_conversion.cpp",
            "inline_exhaustive_pass.cpp",
            "inline_opaque_pass.cpp",
            "inline_pass.cpp",
            "inst_debug_printf_pass.cpp",
            "instruction.cpp",
            "instruction_list.cpp",
            "instrument_pass.cpp",
            "interface_var_sroa.cpp",
            "interp_fixup_pass.cpp",
            "invocation_interlock_placement_pass.cpp",
            "ir_context.cpp",
            "ir_loader.cpp",
            "licm_pass.cpp",
            "liveness.cpp",
            "local_access_chain_convert_pass.cpp",
            "local_redundancy_elimination.cpp",
            "local_single_block_elim_pass.cpp",
            "local_single_store_elim_pass.cpp",
            "loop_dependence.cpp",
            "loop_dependence_helpers.cpp",
            "loop_descriptor.cpp",
            "loop_fission.cpp",
            "loop_fusion.cpp",
            "loop_fusion_pass.cpp",
            "loop_peeling.cpp",
            "loop_unroller.cpp",
            "loop_unswitch_pass.cpp",
            "loop_utils.cpp",
            "mem_pass.cpp",
            "merge_return_pass.cpp",
            "modify_maximal_reconvergence.cpp",
            "module.cpp",
            "opextinst_forward_ref_fixup_pass.cpp",
            "optimizer.cpp",
            "pass.cpp",
            "pass_manager.cpp",
            "pch_source_opt.cpp",
            "private_to_local_pass.cpp",
            "propagator.cpp",
            "reduce_load_size.cpp",
            "redundancy_elimination.cpp",
            "register_pressure.cpp",
            "relax_float_ops_pass.cpp",
            "remove_dontinline_pass.cpp",
            "remove_duplicates_pass.cpp",
            "remove_unused_interface_variables_pass.cpp",
            "replace_desc_array_access_using_var_index.cpp",
            "replace_invalid_opc.cpp",
            "scalar_analysis.cpp",
            "scalar_analysis_simplification.cpp",
            "scalar_replacement_pass.cpp",
            "set_spec_constant_default_value_pass.cpp",
            "simplification_pass.cpp",
            "spread_volatile_semantics.cpp",
            "ssa_rewrite_pass.cpp",
            "strength_reduction_pass.cpp",
            "strip_debug_info_pass.cpp",
            "strip_nonsemantic_info_pass.cpp",
            "struct_cfg_analysis.cpp",
            "switch_descriptorset_pass.cpp",
            "trim_capabilities_pass.cpp",
            "type_manager.cpp",
            "types.cpp",
            "unify_const_pass.cpp",
            "upgrade_memory_model.cpp",
            "value_number_table.cpp",
            "vector_dce.cpp",
            "workaround1209.cpp",
            "wrap_opkill.cpp",
        },
        .flags = flags,
    });
    b.installArtifact(spirv_tools_opt_static);

    // libSPIRC-Tools-reduce
    const spirv_tools_reduce_static = b.addStaticLibrary(.{
        .name = "SPIRV-Tools-reduce",
        .target = target,
        .optimize = optimize,
    });
    spirv_tools_reduce_static.linkLibCpp();
    configureSpirvToolsLibrary(spirv_tools_reduce_static);
    spirv_tools_reduce_static.addCSourceFiles(.{
        .root = spirv_tools_upstream.path("source/reduce"),
        .files = &.{
            "change_operand_reduction_opportunity.cpp",
            "change_operand_to_undef_reduction_opportunity.cpp",
            "conditional_branch_to_simple_conditional_branch_opportunity_finder.cpp",
            "conditional_branch_to_simple_conditional_branch_reduction_opportunity.cpp",
            "merge_blocks_reduction_opportunity.cpp",
            "merge_blocks_reduction_opportunity_finder.cpp",
            "operand_to_const_reduction_opportunity_finder.cpp",
            "operand_to_dominating_id_reduction_opportunity_finder.cpp",
            "operand_to_undef_reduction_opportunity_finder.cpp",
            "pch_source_reduce.cpp",
            "reducer.cpp",
            "reduction_opportunity.cpp",
            "reduction_opportunity_finder.cpp",
            "reduction_pass.cpp",
            "reduction_util.cpp",
            "remove_block_reduction_opportunity.cpp",
            "remove_block_reduction_opportunity_finder.cpp",
            "remove_function_reduction_opportunity.cpp",
            "remove_function_reduction_opportunity_finder.cpp",
            "remove_instruction_reduction_opportunity.cpp",
            "remove_selection_reduction_opportunity.cpp",
            "remove_selection_reduction_opportunity_finder.cpp",
            "remove_struct_member_reduction_opportunity.cpp",
            "remove_unused_instruction_reduction_opportunity_finder.cpp",
            "remove_unused_struct_member_reduction_opportunity_finder.cpp",
            "simple_conditional_branch_to_branch_opportunity_finder.cpp",
            "simple_conditional_branch_to_branch_reduction_opportunity.cpp",
            "structured_construct_to_block_reduction_opportunity.cpp",
            "structured_construct_to_block_reduction_opportunity_finder.cpp",
            "structured_loop_to_selection_reduction_opportunity.cpp",
            "structured_loop_to_selection_reduction_opportunity_finder.cpp",
        },
        .flags = flags,
    });
    b.installArtifact(spirv_tools_reduce_static);

    // spirv-tools-util
    const spirv_tools_util_internal_static = b.addStaticLibrary(.{
        .name = "spirv-tools-util",
        .target = target,
        .optimize = optimize,
    });
    spirv_tools_util_internal_static.linkLibCpp();
    configureSpirvToolsLibrary(spirv_tools_util_internal_static);
    spirv_tools_util_internal_static.addCSourceFiles(.{
        .root = spirv_tools_upstream.path("tools/util"),
        .files = &.{
            "flags.cpp",
            "cli_consumer.cpp",
        },
        .flags = flags,
    });

    // spirv-as
    const spirv_as_exe = b.addExecutable(.{
        .name = "spirv-as",
        .target = target,
        .optimize = optimize,
    });
    spirv_as_exe.linkLibCpp();
    spirv_as_exe.linkLibrary(spirv_tools_static);
    spirv_as_exe.linkLibrary(spirv_tools_util_internal_static);
    configureSpirvToolsBinary(spirv_as_exe);
    spirv_as_exe.addCSourceFiles(.{
        .root = spirv_tools_upstream.path("tools/as"),
        .files = &.{"as.cpp"},
        .flags = flags,
    });
    b.installArtifact(spirv_as_exe);
    const spirv_as_run_cmd = b.addRunArtifact(spirv_as_exe);
    spirv_as_run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| spirv_as_run_cmd.addArgs(args);
    const spirv_as_run_step = b.step("spirv-as", "Run spirv-as");
    spirv_as_run_step.dependOn(&spirv_as_run_cmd.step);

    // spirv-cfg
    const spirv_cfg_exe = b.addExecutable(.{
        .name = "spirv-cfg",
        .target = target,
        .optimize = optimize,
    });
    spirv_cfg_exe.linkLibCpp();
    spirv_cfg_exe.linkLibrary(spirv_tools_static);
    spirv_cfg_exe.linkLibrary(spirv_tools_util_internal_static);
    configureSpirvToolsBinary(spirv_cfg_exe);
    spirv_cfg_exe.addCSourceFiles(.{
        .root = spirv_tools_upstream.path("tools/cfg"),
        .files = &.{
            "bin_to_dot.cpp",
            "cfg.cpp",
        },
        .flags = flags,
    });
    b.installArtifact(spirv_cfg_exe);
    const spirv_cfg_run_cmd = b.addRunArtifact(spirv_cfg_exe);
    spirv_cfg_run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| spirv_cfg_run_cmd.addArgs(args);
    const spirv_cfg_run_step = b.step("spirv-cfg", "Run spirv-cfg");
    spirv_cfg_run_step.dependOn(&spirv_cfg_run_cmd.step);

    // spirv-cfg
    const spirv_dis_exe = b.addExecutable(.{
        .name = "spirv-dis",
        .target = target,
        .optimize = optimize,
    });
    spirv_dis_exe.linkLibCpp();
    spirv_dis_exe.linkLibrary(spirv_tools_static);
    spirv_dis_exe.linkLibrary(spirv_tools_util_internal_static);
    configureSpirvToolsBinary(spirv_dis_exe);
    spirv_dis_exe.addCSourceFiles(.{
        .root = spirv_tools_upstream.path("tools/dis"),
        .files = &.{"dis.cpp"},
        .flags = flags,
    });
    b.installArtifact(spirv_dis_exe);
    const spirv_dis_run_cmd = b.addRunArtifact(spirv_dis_exe);
    spirv_dis_run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| spirv_dis_run_cmd.addArgs(args);
    const spirv_dis_run_step = b.step("spirv-dis", "Run spirv-dis");
    spirv_dis_run_step.dependOn(&spirv_dis_run_cmd.step);

    // spirv-link
    const spirv_link_exe = b.addExecutable(.{
        .name = "spirv-link",
        .target = target,
        .optimize = optimize,
    });
    spirv_link_exe.linkLibCpp();
    spirv_link_exe.linkLibrary(spirv_tools_static);
    spirv_link_exe.linkLibrary(spirv_tools_util_internal_static);
    spirv_link_exe.linkLibrary(spirv_tools_link_static);
    spirv_link_exe.linkLibrary(spirv_tools_opt_static);
    configureSpirvToolsBinary(spirv_link_exe);
    spirv_link_exe.addCSourceFiles(.{
        .root = spirv_tools_upstream.path("tools/link"),
        .files = &.{"linker.cpp"},
        .flags = flags,
    });
    b.installArtifact(spirv_link_exe);
    const spirv_link_run_cmd = b.addRunArtifact(spirv_link_exe);
    spirv_link_run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| spirv_link_run_cmd.addArgs(args);
    const spirv_link_run_step = b.step("spirv-link", "Run spirv-link");
    spirv_link_run_step.dependOn(&spirv_link_run_cmd.step);

    // spirv-lint
    const spirv_lint_exe = b.addExecutable(.{
        .name = "spirv-lint",
        .target = target,
        .optimize = optimize,
    });
    spirv_lint_exe.linkLibCpp();
    spirv_lint_exe.linkLibrary(spirv_tools_static);
    spirv_lint_exe.linkLibrary(spirv_tools_util_internal_static);
    spirv_lint_exe.linkLibrary(spirv_tools_lint_static);
    spirv_lint_exe.linkLibrary(spirv_tools_opt_static);
    configureSpirvToolsBinary(spirv_lint_exe);
    spirv_lint_exe.addCSourceFiles(.{
        .root = spirv_tools_upstream.path("tools/lint"),
        .files = &.{"lint.cpp"},
        .flags = flags,
    });
    b.installArtifact(spirv_lint_exe);
    const spirv_lint_run_cmd = b.addRunArtifact(spirv_lint_exe);
    spirv_lint_run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| spirv_lint_run_cmd.addArgs(args);
    const spirv_lint_run_step = b.step("spirv-lint", "Run spirv-lint");
    spirv_lint_run_step.dependOn(&spirv_lint_run_cmd.step);

    // spirv-objdump
    const spirv_objdump_exe = b.addExecutable(.{
        .name = "spirv-objdump",
        .target = target,
        .optimize = optimize,
    });
    spirv_objdump_exe.linkLibCpp();
    spirv_objdump_exe.linkLibrary(spirv_tools_static);
    spirv_objdump_exe.linkLibrary(spirv_tools_util_internal_static);
    configureSpirvToolsBinary(spirv_objdump_exe);
    spirv_objdump_exe.addCSourceFiles(.{
        .root = spirv_tools_upstream.path("tools/objdump"),
        .files = &.{
            "extract_source.cpp",
            "objdump.cpp",
        },
        .flags = flags,
    });
    b.installArtifact(spirv_objdump_exe);
    const spirv_objdump_run_cmd = b.addRunArtifact(spirv_objdump_exe);
    spirv_objdump_run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| spirv_objdump_run_cmd.addArgs(args);
    const spirv_objdump_run_step = b.step("spirv-objdump", "Run spirv-objdump");
    spirv_objdump_run_step.dependOn(&spirv_objdump_run_cmd.step);

    // spirv-opt
    const spirv_opt_exe = b.addExecutable(.{
        .name = "spirv-opt",
        .target = target,
        .optimize = optimize,
    });
    spirv_opt_exe.linkLibCpp();
    spirv_opt_exe.linkLibrary(spirv_tools_opt_static);
    spirv_opt_exe.linkLibrary(spirv_tools_static);
    spirv_opt_exe.linkLibrary(spirv_tools_util_internal_static);
    configureSpirvToolsBinary(spirv_opt_exe);
    spirv_opt_exe.addCSourceFiles(.{
        .root = spirv_tools_upstream.path("tools/opt"),
        .files = &.{"opt.cpp"},
        .flags = flags,
    });
    b.installArtifact(spirv_opt_exe);
    const spirv_opt_run_cmd = b.addRunArtifact(spirv_opt_exe);
    spirv_opt_run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| spirv_opt_run_cmd.addArgs(args);
    const spirv_opt_run_step = b.step("spirv-opt", "Run spirv-opt");
    spirv_opt_run_step.dependOn(&spirv_opt_run_cmd.step);

    // spirv-reduce
    const spirv_reduce_exe = b.addExecutable(.{
        .name = "spirv-reduce",
        .target = target,
        .optimize = optimize,
    });
    spirv_reduce_exe.linkLibCpp();
    spirv_reduce_exe.linkLibrary(spirv_tools_reduce_static);
    spirv_reduce_exe.linkLibrary(spirv_tools_static);
    spirv_reduce_exe.linkLibrary(spirv_tools_util_internal_static);
    spirv_reduce_exe.linkLibrary(spirv_tools_opt_static);
    configureSpirvToolsBinary(spirv_reduce_exe);
    spirv_reduce_exe.addCSourceFiles(.{
        .root = spirv_tools_upstream.path("tools/reduce"),
        .files = &.{"reduce.cpp"},
        .flags = flags,
    });
    b.installArtifact(spirv_reduce_exe);
    const spirv_reduce_run_cmd = b.addRunArtifact(spirv_reduce_exe);
    spirv_reduce_run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| spirv_reduce_run_cmd.addArgs(args);
    const spirv_reduce_run_step = b.step("spirv-reduce", "Run spirv-reduce");
    spirv_reduce_run_step.dependOn(&spirv_reduce_run_cmd.step);

    // spirv-val
    const spirv_val_exe = b.addExecutable(.{
        .name = "spirv-val",
        .target = target,
        .optimize = optimize,
    });
    spirv_val_exe.linkLibCpp();
    spirv_val_exe.linkLibrary(spirv_tools_static);
    spirv_val_exe.linkLibrary(spirv_tools_util_internal_static);
    configureSpirvToolsBinary(spirv_val_exe);
    spirv_val_exe.addCSourceFiles(.{
        .root = spirv_tools_upstream.path("tools/val"),
        .files = &.{"val.cpp"},
        .flags = flags,
    });
    b.installArtifact(spirv_val_exe);
    const spirv_val_run_cmd = b.addRunArtifact(spirv_val_exe);
    spirv_val_run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| spirv_val_run_cmd.addArgs(args);
    const spirv_val_run_step = b.step("spirv-val", "Run spirv-val");
    spirv_val_run_step.dependOn(&spirv_val_run_cmd.step);

    // spirv-lesspipe.sh
    const spirv_lesspipe_bin = b.addInstallBinFile(
        spirv_tools_upstream.path("tools/lesspipe/spirv-lesspipe.sh"),
        "spirv-lesspipe.sh",
    );
    b.getInstallStep().dependOn(&spirv_lesspipe_bin.step);

    // libGenericCodeGen
    const generic_code_gen_static = b.addStaticLibrary(.{
        .name = "GenericCodeGen",
        .target = target,
        .optimize = optimize,
    });
    generic_code_gen_static.linkLibCpp();
    generic_code_gen_static.addCSourceFiles(.{
        .root = glslang_upstream.path("glslang/GenericCodeGen"),
        .files = &.{
            "CodeGen.cpp",
            "Link.cpp",
        },
        .flags = flags,
    });
    configureGlslangLibrary(generic_code_gen_static, enable_opt);
    b.installArtifact(generic_code_gen_static);

    // libglslang-default-resource-limits
    const glslang_default_resource_limits_static = b.addStaticLibrary(.{
        .name = "glslang-default-resource-limits",
        .target = target,
        .optimize = optimize,
    });
    glslang_default_resource_limits_static.linkLibCpp();
    glslang_default_resource_limits_static.addCSourceFiles(.{
        .root = glslang_upstream.path("glslang/ResourceLimits"),
        .files = &.{
            "resource_limits_c.cpp",
            "ResourceLimits.cpp",
        },
        .flags = flags,
    });
    configureGlslangLibrary(glslang_default_resource_limits_static, enable_opt);
    b.installArtifact(glslang_default_resource_limits_static);

    // libMachineIndependent
    const machine_independent_static = b.addStaticLibrary(.{
        .name = "MachineIndependent",
        .target = target,
        .optimize = optimize,
    });
    machine_independent_static.linkLibCpp();
    machine_independent_static.addCSourceFiles(.{
        .root = glslang_upstream.path("glslang/MachineIndependent"),
        .files = &.{
            "attribute.cpp",
            "Constant.cpp",
            "glslang_tab.cpp",
            "InfoSink.cpp",
            "Initialize.cpp",
            "Intermediate.cpp",
            "intermOut.cpp",
            "IntermTraverse.cpp",
            "iomapper.cpp",
            "limits.cpp",
            "linkValidate.cpp",
            "parseConst.cpp",
            "ParseContextBase.cpp",
            "ParseHelper.cpp",
            "PoolAlloc.cpp",
            "preprocessor/Pp.cpp",
            "preprocessor/PpAtom.cpp",
            "preprocessor/PpContext.cpp",
            "preprocessor/PpScanner.cpp",
            "preprocessor/PpTokens.cpp",
            "propagateNoContraction.cpp",
            "reflection.cpp",
            "RemoveTree.cpp",
            "Scan.cpp",
            "ShaderLang.cpp",
            "SpirvIntrinsics.cpp",
            "SymbolTable.cpp",
            "Versions.cpp",
        },
        .flags = flags,
    });
    configureGlslangLibrary(machine_independent_static, enable_opt);
    b.installArtifact(machine_independent_static);

    // libOSDependent
    const os_dependent_static = b.addStaticLibrary(.{
        .name = "OSDependent",
        .target = target,
        .optimize = optimize,
    });
    os_dependent_static.linkLibCpp();
    configureGlslangLibrary(os_dependent_static, enable_opt);
    os_dependent_static.addCSourceFiles(.{
        .root = glslang_upstream.path(""),
        .files = if (target.result.os.tag == .windows)
            &[_][]const u8{"glslang/OSDependent/Windows/ossource.cpp"}
        else
            &[_][]const u8{"glslang/OSDependent/Unix/ossource.cpp"},
        .flags = flags,
    });
    b.installArtifact(os_dependent_static);

    // libSPIRV
    const spirv_static = b.addStaticLibrary(.{
        .name = "SPIRV",
        .target = target,
        .optimize = optimize,
    });
    spirv_static.linkLibCpp();
    if (enable_opt) spirv_static.linkLibrary(spirv_tools_opt_static);
    configureGlslangLibrary(spirv_static, enable_opt);
    spirv_static.addCSourceFiles(.{
        .root = glslang_upstream.path("SPIRV"),
        .files = &.{
            "CInterface/spirv_c_interface.cpp",
            "disassemble.cpp",
            "doc.cpp",
            "GlslangToSpv.cpp",
            "InReadableOrder.cpp",
            "Logger.cpp",
            "SpvBuilder.cpp",
            "SpvPostProcess.cpp",
            "SpvTools.cpp",
        },
        .flags = flags,
    });
    b.installArtifact(spirv_static);

    // libSPVRemapper
    const spv_remapper_static = b.addStaticLibrary(.{
        .name = "SPVRemapper",
        .target = target,
        .optimize = optimize,
    });
    spv_remapper_static.linkLibCpp();
    configureGlslangLibrary(spv_remapper_static, enable_opt);
    spv_remapper_static.addCSourceFiles(.{
        .root = glslang_upstream.path("SPIRV"),
        .files = &.{"SPVRemapper.cpp"},
        .flags = flags,
    });
    b.installArtifact(spv_remapper_static);

    // libglslang
    const glslang_static = b.addStaticLibrary(.{
        .name = "glslang",
        .target = target,
        .optimize = optimize,
    });
    glslang_static.linkLibCpp();
    glslang_static.linkLibrary(spirv_tools_static);
    glslang_static.linkLibrary(generic_code_gen_static);
    glslang_static.linkLibrary(glslang_default_resource_limits_static);
    glslang_static.linkLibrary(machine_independent_static);
    glslang_static.linkLibrary(spirv_static);
    if (enable_opt) glslang_static.linkLibrary(spirv_tools_opt_static);
    configureGlslangLibrary(glslang_static, enable_opt);
    glslang_static.addCSourceFiles(.{
        .root = glslang_upstream.path(""),
        .files = &.{"glslang/CInterface/glslang_c_interface.cpp"},
        .flags = flags,
    });
    b.installArtifact(glslang_static);

    // glslang
    const glslang_exe = b.addExecutable(.{
        .name = "glslangValidator",
        .target = target,
        .optimize = optimize,
    });
    glslang_exe.linkLibCpp();
    glslang_exe.linkLibrary(glslang_static);
    glslang_static.linkLibrary(os_dependent_static);
    glslang_exe.addCSourceFiles(.{
        .root = glslang_upstream.path("StandAlone"),
        .files = &.{"StandAlone.cpp"},
        .flags = flags,
    });
    configureGlslangBinary(glslang_exe, enable_opt);
    b.installArtifact(glslang_exe);
    const glslang_run_cmd = b.addRunArtifact(glslang_exe);
    glslang_run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| glslang_run_cmd.addArgs(args);
    const glslang_run_step = b.step("glslang", "Run glslang");
    glslang_run_step.dependOn(&glslang_run_cmd.step);

    // spirv-remap
    const spirv_remap_exe = b.addExecutable(.{
        .name = "spirv-remap",
        .target = target,
        .optimize = optimize,
    });
    spirv_remap_exe.linkLibCpp();
    spirv_remap_exe.linkLibrary(spv_remapper_static);
    spirv_remap_exe.linkLibrary(spirv_static);
    spirv_remap_exe.addCSourceFiles(.{
        .root = glslang_upstream.path("StandAlone"),
        .files = &.{"spirv-remap.cpp"},
        .flags = flags,
    });
    configureGlslangBinary(spirv_remap_exe, enable_opt);
    b.installArtifact(spirv_remap_exe);
    const spirv_remap_run_cmd = b.addRunArtifact(spirv_remap_exe);
    spirv_remap_run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| spirv_remap_run_cmd.addArgs(args);
    const spirv_remap_run_step = b.step("spirv-remap", "Run spirv-remap");
    spirv_remap_run_step.dependOn(&spirv_remap_run_cmd.step);
}

fn configureSpirvToolsBinary(compile: *std.Build.Step.Compile) void {
    const b = compile.step.owner;
    const spirv_headers_upstream = b.dependency("SPIRV-Headers", .{});
    const spirv_tools_upstream = b.dependency("SPIRV-Tools", .{});

    compile.addIncludePath(spirv_tools_upstream.path(""));
    compile.addIncludePath(spirv_tools_upstream.path("include"));
    compile.addIncludePath(spirv_headers_upstream.path("include"));
    compile.addIncludePath(b.path("generated/spirv-tools"));
}

fn configureSpirvToolsLibrary(lib: *std.Build.Step.Compile) void {
    std.debug.assert(lib.kind != .exe);
    const b = lib.step.owner;
    const spirv_tools_upstream = b.dependency("SPIRV-Tools", .{});

    lib.installHeader(
        spirv_tools_upstream.path("include/spirv-tools/instrument.hpp"),
        "spirv-tools/instrument.hpp",
    );
    lib.installHeader(
        spirv_tools_upstream.path("include/spirv-tools/libspirv.h"),
        "spirv-tools/libspirv.h",
    );
    lib.installHeader(
        spirv_tools_upstream.path("include/spirv-tools/libspirv.hpp"),
        "spirv-tools/libspirv.hpp",
    );
    lib.installHeader(
        spirv_tools_upstream.path("include/spirv-tools/linker.hpp"),
        "spirv-tools/linker.hpp",
    );
    lib.installHeader(
        spirv_tools_upstream.path("include/spirv-tools/optimizer.hpp"),
        "spirv-tools/optimizer.hpp",
    );

    configureSpirvToolsBinary(lib);
}

fn configureGlslangBinary(compile: *std.Build.Step.Compile, enable_opt: bool) void {
    const b = compile.step.owner;
    const glslang_upstream = b.dependency("glslang", .{});

    compile.addIncludePath(glslang_upstream.path(""));
    compile.addIncludePath(b.path("generated/glslang"));

    compile.defineCMacro("ENABLE_OPT", if (enable_opt) "1" else "0");
}

fn configureGlslangLibrary(lib: *std.Build.Step.Compile, enable_opt: bool) void {
    std.debug.assert(lib.kind != .exe);

    const b = lib.step.owner;
    const glslang_upstream = b.dependency("glslang", .{});

    lib.installHeader(
        glslang_upstream.path("glslang/Include/glslang_c_interface.h"),
        "glslang/Include/glslang_c_interface.h",
    );
    lib.installHeader(
        glslang_upstream.path("glslang/Include/glslang_c_shader_types.h"),
        "glslang/Include/glslang_c_shader_types.h",
    );
    lib.installHeader(
        glslang_upstream.path("glslang/Include/ResourceLimits.h"),
        "glslang/Include/ResourceLimits.h",
    );

    lib.installHeader(
        glslang_upstream.path("glslang/MachineIndependent/Versions.h"),
        "glslang/MachineIndependent/Versions.h",
    );

    lib.installHeadersDirectory(
        glslang_upstream.path("glslang/Public"),
        "glslang/Public",
        .{ .include_extensions = &[_][]const u8{ ".h", ".hpp", ".hpp11" } },
    );

    lib.installHeader(
        glslang_upstream.path("SPIRV/disassemble.h"),
        "glslang/SPIRV/disassemble.h",
    );
    lib.installHeader(
        glslang_upstream.path("SPIRV/GlslangToSpv.h"),
        "glslang/SPIRV/GlslangToSpv.h",
    );
    lib.installHeader(
        glslang_upstream.path("SPIRV/Logger.h"),
        "glslang/SPIRV/Logger.h",
    );
    lib.installHeader(
        glslang_upstream.path("SPIRV/spirv.hpp"),
        "glslang/SPIRV/spirv.hpp",
    );
    lib.installHeader(
        glslang_upstream.path("SPIRV/SPVRemapper.h"),
        "glslang/SPIRV/SPVRemapper.h",
    );

    lib.installHeader(
        b.path("generated/glslang/glslang/build_info.h"),
        "glslang/build_info.h",
    );

    configureGlslangBinary(lib, enable_opt);
}
