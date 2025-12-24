wvCreateWindow
wvRestoreSignal -win $_nWave2 -openDumpFile "signal.rc" "wave.fsdb" \
           -overWriteAutoAlias on -appendSignals on
verdiSetActWin -win $_nWave2
verdiWindowResize -win $_Verdi_1 "0" "0" "1920" "1052"
verdiSetActWin -dock widgetDock_MTB_SOURCE_TAB_1
verdiDockWidgetMaximize -dock windowDock_nWave_2
verdiSetActWin -win $_nWave2
wvSelectSignal -win $_nWave2 {( "IF" 5 )} 
wvGetSignalOpen -win $_nWave2
wvGetSignalClose -win $_nWave2
wvSetCursor -win $_nWave2 428.949584 -snap {("IF" 2)}
wvGetSignalOpen -win $_nWave2
wvGetSignalSetScope -win $_nWave2 "/tb_top_vcs"
wvGetSignalSetScope -win $_nWave2 "/tb_top_vcs/TOP"
wvGetSignalSetScope -win $_nWave2 "/tb_top_vcs/TOP/AXI"
wvGetSignalSetScope -win $_nWave2 "/tb_top_vcs/TOP/core_0"
wvGetSignalSetScope -win $_nWave2 "/tb_top_vcs/TOP/core_0/core_0"
wvGetSignalSetScope -win $_nWave2 "/tb_top_vcs/TOP/core_0/core_0/ID2EX_buffer"
wvGetSignalSetScope -win $_nWave2 "/tb_top_vcs/TOP/core_0/core_0/ID_stage"
wvGetSignalSetScope -win $_nWave2 "/tb_top_vcs/TOP/core_0/core_0/IF2ID_buffer"
wvGetSignalSetScope -win $_nWave2 "/tb_top_vcs/TOP/core_0/core_0/IF_stage"
wvGetSignalSetScope -win $_nWave2 "/tb_top_vcs/TOP/mem0"
wvGetSignalSetScope -win $_nWave2 "/tb_top_vcs/TOP/core_0/core_0/ID2EX_buffer"
wvGetSignalSetScope -win $_nWave2 "/tb_top_vcs/TOP/core_0/core_0/IF2ID_buffer"
wvSetPosition -win $_nWave2 {("ID_EX" 3)}
wvSetPosition -win $_nWave2 {("ID_EX" 3)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"System" \
{/tb_top_vcs/TOP/core_0/core_0/ACLK} \
{/tb_top_vcs/TOP/core_0/core_0/ARESETn} \
{/tb_top_vcs/TOP/core_0/core_0/global_stall_en} \
{/tb_top_vcs/TOP/core_0/imem_req_resp} \
}
wvAddSignal -win $_nWave2 -group {"AXI" \
{/tb_top_vcs/TOP/AXI/ARADDR_M0\[31:0\]} \
{/tb_top_vcs/TOP/AXI/ARREADY_M0} \
{/tb_top_vcs/TOP/AXI/ARVALID_M0} \
{/tb_top_vcs/TOP/AXI/RDATA_M0\[31:0\]} \
{/tb_top_vcs/TOP/AXI/RREADY_M0} \
{/tb_top_vcs/TOP/AXI/RVALID_M0} \
}
wvAddSignal -win $_nWave2 -group {"memory" \
{/tb_top_vcs/TOP/mem0/mem0/imem_addr\[31:0\]} \
{/tb_top_vcs/TOP/mem0/mem0/valid_imem_addr\[14:0\]} \
{/tb_top_vcs/TOP/mem0/mem0/imem_ren} \
{/tb_top_vcs/TOP/mem0/mem0/imem_rdata\[31:0\]} \
{/tb_top_vcs/TOP/mem0/mem0/dmem_addr\[31:0\]} \
{/tb_top_vcs/TOP/mem0/mem0/valid_dmem_addr\[14:0\]} \
{/tb_top_vcs/TOP/mem0/mem0/dmem_ren} \
{/tb_top_vcs/TOP/mem0/mem0/dmem_rdata\[31:0\]} \
{/tb_top_vcs/TOP/mem0/mem0/dmem_wen} \
{/tb_top_vcs/TOP/mem0/mem0/dmem_wstrb\[3:0\]} \
{/tb_top_vcs/TOP/mem0/mem0/dmem_wdata\[31:0\]} \
}
wvAddSignal -win $_nWave2 -group {"IF" \
{/tb_top_vcs/TOP/core_0/core_0/IF_stage/stall_en} \
{/tb_top_vcs/TOP/core_0/core_0/IF_stage/jump_en} \
{/tb_top_vcs/TOP/core_0/core_0/IF_stage/jump_addr_i\[31:0\]} \
{/tb_top_vcs/TOP/core_0/core_0/IF_stage/pc_o\[31:0\]} \
{/tb_top_vcs/TOP/core_0/core_0/IF_stage/pc_next_o\[31:0\]} \
}
wvAddSignal -win $_nWave2 -group {"IF_ID" \
{/tb_top_vcs/TOP/core_0/core_0/IF2ID_buffer/flush_en_i} \
{/tb_top_vcs/TOP/core_0/core_0/IF2ID_buffer/stall_en_i} \
}
wvAddSignal -win $_nWave2 -group {"ID" \
{/tb_top_vcs/TOP/core_0/core_0/ID_stage/rd_idx_o\[4:0\]} \
{/tb_top_vcs/TOP/core_0/core_0/ID_stage/rs1_idx_o\[4:0\]} \
{/tb_top_vcs/TOP/core_0/core_0/ID_stage/rs2_idx_o\[4:0\]} \
}
wvAddSignal -win $_nWave2 -group {"ID_EX" \
{/tb_top_vcs/TOP/core_0/core_0/ID2EX_buffer/flush_en} \
{/tb_top_vcs/TOP/core_0/core_0/ID2EX_buffer/stall_en} \
{/tb_top_vcs/TOP/core_0/core_0/IF2ID_buffer/if_id_bus_in} \
}
wvAddSignal -win $_nWave2 -group {"G8" \
}
wvSelectSignal -win $_nWave2 {( "ID_EX" 3 )} 
wvSetPosition -win $_nWave2 {("ID_EX" 3)}
wvSetPosition -win $_nWave2 {("ID_EX" 3)}
wvSetPosition -win $_nWave2 {("ID_EX" 3)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"System" \
{/tb_top_vcs/TOP/core_0/core_0/ACLK} \
{/tb_top_vcs/TOP/core_0/core_0/ARESETn} \
{/tb_top_vcs/TOP/core_0/core_0/global_stall_en} \
{/tb_top_vcs/TOP/core_0/imem_req_resp} \
}
wvAddSignal -win $_nWave2 -group {"AXI" \
{/tb_top_vcs/TOP/AXI/ARADDR_M0\[31:0\]} \
{/tb_top_vcs/TOP/AXI/ARREADY_M0} \
{/tb_top_vcs/TOP/AXI/ARVALID_M0} \
{/tb_top_vcs/TOP/AXI/RDATA_M0\[31:0\]} \
{/tb_top_vcs/TOP/AXI/RREADY_M0} \
{/tb_top_vcs/TOP/AXI/RVALID_M0} \
}
wvAddSignal -win $_nWave2 -group {"memory" \
{/tb_top_vcs/TOP/mem0/mem0/imem_addr\[31:0\]} \
{/tb_top_vcs/TOP/mem0/mem0/valid_imem_addr\[14:0\]} \
{/tb_top_vcs/TOP/mem0/mem0/imem_ren} \
{/tb_top_vcs/TOP/mem0/mem0/imem_rdata\[31:0\]} \
{/tb_top_vcs/TOP/mem0/mem0/dmem_addr\[31:0\]} \
{/tb_top_vcs/TOP/mem0/mem0/valid_dmem_addr\[14:0\]} \
{/tb_top_vcs/TOP/mem0/mem0/dmem_ren} \
{/tb_top_vcs/TOP/mem0/mem0/dmem_rdata\[31:0\]} \
{/tb_top_vcs/TOP/mem0/mem0/dmem_wen} \
{/tb_top_vcs/TOP/mem0/mem0/dmem_wstrb\[3:0\]} \
{/tb_top_vcs/TOP/mem0/mem0/dmem_wdata\[31:0\]} \
}
wvAddSignal -win $_nWave2 -group {"IF" \
{/tb_top_vcs/TOP/core_0/core_0/IF_stage/stall_en} \
{/tb_top_vcs/TOP/core_0/core_0/IF_stage/jump_en} \
{/tb_top_vcs/TOP/core_0/core_0/IF_stage/jump_addr_i\[31:0\]} \
{/tb_top_vcs/TOP/core_0/core_0/IF_stage/pc_o\[31:0\]} \
{/tb_top_vcs/TOP/core_0/core_0/IF_stage/pc_next_o\[31:0\]} \
}
wvAddSignal -win $_nWave2 -group {"IF_ID" \
{/tb_top_vcs/TOP/core_0/core_0/IF2ID_buffer/flush_en_i} \
{/tb_top_vcs/TOP/core_0/core_0/IF2ID_buffer/stall_en_i} \
}
wvAddSignal -win $_nWave2 -group {"ID" \
{/tb_top_vcs/TOP/core_0/core_0/ID_stage/rd_idx_o\[4:0\]} \
{/tb_top_vcs/TOP/core_0/core_0/ID_stage/rs1_idx_o\[4:0\]} \
{/tb_top_vcs/TOP/core_0/core_0/ID_stage/rs2_idx_o\[4:0\]} \
}
wvAddSignal -win $_nWave2 -group {"ID_EX" \
{/tb_top_vcs/TOP/core_0/core_0/ID2EX_buffer/flush_en} \
{/tb_top_vcs/TOP/core_0/core_0/ID2EX_buffer/stall_en} \
{/tb_top_vcs/TOP/core_0/core_0/IF2ID_buffer/if_id_bus_in} \
}
wvAddSignal -win $_nWave2 -group {"G8" \
}
wvSelectSignal -win $_nWave2 {( "ID_EX" 3 )} 
wvSetPosition -win $_nWave2 {("ID_EX" 3)}
wvGetSignalClose -win $_nWave2
wvSetPosition -win $_nWave2 {("ID_EX" 2)}
wvSetPosition -win $_nWave2 {("ID_EX" 1)}
wvSetPosition -win $_nWave2 {("ID_EX" 0)}
wvSetPosition -win $_nWave2 {("ID" 3)}
wvSetPosition -win $_nWave2 {("ID" 2)}
wvSetPosition -win $_nWave2 {("ID" 1)}
wvSetPosition -win $_nWave2 {("IF_ID" 2)}
wvSetPosition -win $_nWave2 {("IF_ID" 1)}
wvSetPosition -win $_nWave2 {("IF_ID" 0)}
wvSetPosition -win $_nWave2 {("IF" 5)}
wvMoveSelected -win $_nWave2
wvSetPosition -win $_nWave2 {("IF" 5)}
wvSetPosition -win $_nWave2 {("IF" 6)}
wvSelectSignal -win $_nWave2 {( "IF" 6 )} 
wvExpandBus -win $_nWave2
wvSelectSignal -win $_nWave2 {( "IF" 6 )} 
wvSetPosition -win $_nWave2 {("IF" 6)}
wvSetPosition -win $_nWave2 {("IF" 7)}
wvSetPosition -win $_nWave2 {("IF" 6)}
wvMoveSelected -win $_nWave2
wvSetPosition -win $_nWave2 {("IF" 6)}
wvSelectSignal -win $_nWave2 {( "IF" 8 )} 
wvSelectSignal -win $_nWave2 {( "IF" 9 )} 
wvSelectSignal -win $_nWave2 {( "IF" 8 )} 
wvSelectSignal -win $_nWave2 {( "IF" 8 9 )} 
wvCut -win $_nWave2
wvSetPosition -win $_nWave2 {("IF" 6)}
wvSelectSignal -win $_nWave2 {( "IF" 6 )} 
wvCut -win $_nWave2
wvSetPosition -win $_nWave2 {("IF" 6)}
wvSetPosition -win $_nWave2 {("IF" 5)}
wvSelectSignal -win $_nWave2 {( "IF" 6 )} 
wvScrollDown -win $_nWave2 0
wvSaveSignal -win $_nWave2 "/home/eric1231/code/5-rv32i/signal.rc"
wvSetCursor -win $_nWave2 343.239257 -snap {("memory" 8)}
wvSetCursor -win $_nWave2 125.858534 -snap {("System" 1)}
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchPrev -win $_nWave2
wvSearchPrev -win $_nWave2
wvSearchPrev -win $_nWave2
wvSearchPrev -win $_nWave2
wvSearchPrev -win $_nWave2
wvSearchPrev -win $_nWave2
wvSearchNext -win $_nWave2
wvSelectSignal -win $_nWave2 {( "System" 1 )} 
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSetCursor -win $_nWave2 396.594379 -snap {("System" 1)}
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSetCursor -win $_nWave2 443.336800 -snap {("AXI" 2)}
wvSetCursor -win $_nWave2 61.680670 -snap {("System" 1)}
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSetCursor -win $_nWave2 386.278320
wvSetCursor -win $_nWave2 385.154583
wvSetMarker -win $_nWave2 -keepViewRange -name "first jump" 385.155 ID_GREEN5 \
           long_dashed
wvReportMarker -win $_nWave2 -toFile "/home/eric1231/code/5-rv32i/marker.rpt"
wvSetCursor -win $_nWave2 402.385216
wvSetCursor -win $_nWave2 417.867813 -snap {("System" 0)}
wvSetCursor -win $_nWave2 421.738462
wvSetCursor -win $_nWave2 428.356024
wvUnselectUserMarker -win $_nWave2
wvSetCursor -win $_nWave2 395.393075
wvSetCursor -win $_nWave2 394.768776
wvSetMarker -win $_nWave2 -keepViewRange -name "send wrong address request" \
           385.155 ID_GREEN5 long_dashed
wvReportMarker -win $_nWave2 -toFile "/home/eric1231/code/5-rv32i/marker.rpt"
wvUnselectUserMarker -win $_nWave2
wvSetCursor -win $_nWave2 417.243515 -snap {("System" 0)}
wvSetCursor -win $_nWave2 399.014005 -snap {("System" 1)}
wvSetCursor -win $_nWave2 407.879040 -snap {("System" 2)}
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSelectUserMarker -win $_nWave2 -name "send wrong address request"
wvSelectUserMarker -win $_nWave2 -name "send wrong address request"
wvSelectUserMarker -win $_nWave2 -name "send wrong address request"
wvSelectUserMarker -win $_nWave2 -name "send wrong address request"
wvSetMarkerOption -win $_nWave2 -refmarker "send wrong address request"
wvDeleteMarker -win $_nWave2 "send wrong address request"
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSetCursor -win $_nWave2 313.513640 -snap {("System" 1)}
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSetCursor -win $_nWave2 395.003295
wvSetMarker -win $_nWave2 -keepViewRange -name "M1" 404.992
wvSetMarker -win $_nWave2 -keepViewRange -name "M1" 404.992
wvUnselectUserMarker -win $_nWave2
wvSetMarker -win $_nWave2 -keepViewRange -name "M1" 404.992 ID_GREEN5 long_dashed
wvSetMarker -win $_nWave2 -keepViewRange -name "M1" 404.992 ID_GREEN5 long_dashed
wvSetMarker -win $_nWave2 -keepViewRange -name "send wrong IMEM request" 404.992 \
           ID_GREEN5 long_dashed
wvDeleteMarker -win $_nWave2 "M1"
wvDeleteMarker -win $_nWave2 "send wrong IMEM request"
wvReportMarker -win $_nWave2 -toFile "/home/eric1231/code/5-rv32i/marker.rpt"
wvUnselectUserMarker -win $_nWave2
wvUnselectUserMarker -win $_nWave2
wvUnselectUserMarker -win $_nWave2
wvUnselectUserMarker -win $_nWave2
wvSetCursor -win $_nWave2 424.220454 -snap {("memory" 6)}
wvSetCursor -win $_nWave2 91.771848 -snap {("AXI" 3)}
wvSetCursor -win $_nWave2 115.994621 -snap {("AXI" 3)}
wvSetCursor -win $_nWave2 212.611455 -snap {("AXI" 5)}
wvSetCursor -win $_nWave2 223.099666 -snap {("AXI" 4)}
wvSetCursor -win $_nWave2 233.088438 -snap {("AXI" 3)}
wvSetCursor -win $_nWave2 254.189720 -snap {("AXI" 4)}
wvSetCursor -win $_nWave2 270.671195 -snap {("AXI" 5)}
wvSetCursor -win $_nWave2 273.293248 -snap {("AXI" 5)}
wvSetCursor -win $_nWave2 269.048019 -snap {("AXI" 5)}
wvSetCursor -win $_nWave2 267.549704 -snap {("AXI" 3)}
wvSetCursor -win $_nWave2 266.800546 -snap {("AXI" 3)}
wvSetCursor -win $_nWave2 395.318590 -snap {("System" 0)}
wvSetCursor -win $_nWave2 395.568309
wvSetCursor -win $_nWave2 395.193731
wvSetMarker -win $_nWave2 -keepViewRange -name "M2" 395.194
wvSetMarker -win $_nWave2 -keepViewRange -name "M2" 395.194
wvSelectUserMarker -win $_nWave2 -name "M2"
wvSelectUserMarker -win $_nWave2 -name "M2"
wvSetCursor -win $_nWave2 398.190362
wvSetCursor -win $_nWave2 395.068871 -snap {("System" 0)}
wvSelectGroup -win $_nWave2 {System}
wvSetMarker -win $_nWave2 -keepViewRange -name "M2" 395.194 ID_GREEN5 long_dashed
wvSetMarker -win $_nWave2 -keepViewRange -name "M2" 395.194 ID_GREEN5 long_dashed
wvSetMarker -win $_nWave2 -keepViewRange -name "M2" 395.194 ID_GREEN5 long_dashed
wvSetMarker -win $_nWave2 -keepViewRange -name "M2" 395.194 ID_GREEN5 long_dashed
wvSetMarker -win $_nWave2 -keepViewRange -name "M2" 395.194 ID_GREEN5 long_dashed
wvSetMarker -win $_nWave2 -keepViewRange -name "M2" 395.194 ID_GREEN5 long_dashed
wvSetMarker -win $_nWave2 -keepViewRange -name "M2" 395.194 ID_GREEN5 long_dashed
wvSetMarker -win $_nWave2 -keepViewRange -name "M2" 395.194 ID_GREEN5 long_dashed
wvSetMarker -win $_nWave2 -keepViewRange -name "M2" 395.194 ID_GREEN5 long_dashed
wvSetMarker -win $_nWave2 -keepViewRange -name "M2" 395.194 ID_GREEN5 long_dashed
wvSetMarker -win $_nWave2 -keepViewRange -name "M2" 395.194 ID_GREEN5 long_dashed
wvSetMarker -win $_nWave2 -keepViewRange -name "M2" 395.194 ID_GREEN5 long_dashed
wvSetMarker -win $_nWave2 -keepViewRange -name "M2" 395.194 ID_GREEN5 long_dashed \
           -newname "send wrong IMEM address"
wvReportMarker -win $_nWave2 -toFile "/home/eric1231/code/5-rv32i/marker.rpt"
wvSetCursor -win $_nWave2 420.914820 -snap {("System" 2)}
wvSetCursor -win $_nWave2 238.070339 -snap {("AXI" 1)}
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvSelectUserMarker -win $_nWave2 -name "send wrong IMEM address"
wvSelectUserMarker -win $_nWave2 -name "send wrong IMEM address"
wvSelectUserMarker -win $_nWave2 -name "send wrong IMEM address"
wvSelectUserMarker -win $_nWave2 -name "send wrong IMEM address"
wvSelectUserMarker -win $_nWave2 -name "send wrong IMEM address"
wvSelectUserMarker -win $_nWave2 -name "send wrong IMEM address"
wvSetCursor -win $_nWave2 246.747654 -snap {("System" 0)}
wvSetCursor -win $_nWave2 257.610444 -snap {("System" 0)}
wvSetCursor -win $_nWave2 258.234742
wvJumpToolbarUserMarker -win $_nWave2 -name "send wrong IMEM address"
wvSetCursor -win $_nWave2 415.358835
wvSetCursor -win $_nWave2 414.609677
wvSetCursor -win $_nWave2 414.609677
wvSetCursor -win $_nWave2 414.984256
wvSetCursor -win $_nWave2 414.984256 -snap {("AXI" 6)}
wvSelectSignal -win $_nWave2 {( "AXI" 6 )} 
wvSetMarker -win $_nWave2 -keepViewRange -name "M3" 415.109
wvSetMarker -win $_nWave2 -keepViewRange -name "M3" 415.109
wvSetMarker -win $_nWave2 -keepViewRange -name "M3" 415.109 ID_GREEN5 long_dashed \
           -newname "wrong instruction valid"
wvReportMarker -win $_nWave2 -toFile "/home/eric1231/code/5-rv32i/marker.rpt"
wvSetCursor -win $_nWave2 435.211520 -snap {("System" 4)}
wvSetCursor -win $_nWave2 339.444163 -snap {("System" 0)}
wvSetCursor -win $_nWave2 337.446409 -snap {("System" 1)}
wvSearchNext -win $_nWave2
wvSetCursor -win $_nWave2 421.476958 -snap {("System" 0)}
wvSelectSignal -win $_nWave2 {( "System" 1 )} 
wvJumpToolbarUserMarker -win $_nWave2 -name "wrong instruction valid"
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvSetCursor -win $_nWave2 424.910483 -snap {("AXI" 1)}
wvSetCursor -win $_nWave2 405.057798 -snap {("System" 1)}
wvSetCursor -win $_nWave2 414.172553 -snap {("System" 1)}
wvSetCursor -win $_nWave2 425.409922 -snap {("System" 1)}
