FUNCTION phiimqo27jyp_ltpnst7rw.
*"----------------------------------------------------------------------
*"*"Локальный интерфейс:
*"  TABLES
*"      T_PARAMETERS TYPE  ZTTCCMS_PARAMETERS_VALUE
*"----------------------------------------------------------------------
  DATA lv_cpu_user_utilization TYPE i.
  DATA lv_cpu_system_utilization TYPE i.
  DATA lv_cpu_wait TYPE i.
  DATA lv_cpu_1_minload_average TYPE i.
  DATA lv_cpu_5_minload_average TYPE i.
  DATA lv_cpu_15_minload_average TYPE i.
  DATA lv_cpu_context_switches TYPE i.
  DATA lv_cpu_system_calls TYPE i.
  DATA lv_cpu_interrupts TYPE i.
  DATA lt_cpu_all TYPE STANDARD TABLE OF cpu_all.
  TYPES BEGIN OF ts_proccess.
  TYPES dia TYPE i.
  TYPES dia_free TYPE i.
  TYPES dia_queue TYPE i.
  TYPES upd TYPE i.
  TYPES upd_free TYPE i.
  TYPES upd_queue TYPE i.
  TYPES upd2 TYPE i.
  TYPES upd2_free TYPE i.
  TYPES upd2_queue TYPE i.
  TYPES btc TYPE i.
  TYPES btc_free TYPE i.
  TYPES btc_queue TYPE i.
  TYPES spo TYPE i.
  TYPES spo_free TYPE i.
  TYPES spo_queue TYPE i.
  TYPES END   OF ts_proccess.
  DATA ls_proccess TYPE ts_proccess.
  TYPES BEGIN OF ts_print.
  TYPES print TYPE i.
  TYPES no_print TYPE i.
  TYPES END   OF ts_print.
  DATA ls_print TYPE ts_print.
  DATA lt_queue TYPE STANDARD TABLE OF queue_info_new.
  DATA lv_server TYPE msname2.
  CONSTANTS lc_opcode_25 TYPE x VALUE 25.
  CONSTANTS lc_opcode_67 TYPE x VALUE 67.
  TYPES BEGIN OF ts_em.
  TYPES blocksizekb LIKE emutilize-blcksizekb.
  TYPES slotsexisting LIKE emutilize-slotsexist.
  TYPES slotsused LIKE emutilize-slotsused.
  TYPES slotsallocated LIKE emutilize-slotsalloc.
  TYPES slotsattached LIKE emutilize-slostatach.
  TYPES heapusedsum LIKE emutilize-heapusesum.
  TYPES privwpno LIKE emutilize-privwpno.
  TYPES emslotsused LIKE emutilize-emslotsuse.
  TYPES emslotsusedpeak LIKE emutilize-emslotpeak.
  TYPES emslotstotal LIKE emutilize-emslotstot.
  TYPES heapusedsumkb LIKE emutilize-heapsumkb.
  TYPES heapusedsumpeakkb LIKE emutilize-heapsmpeak.
  TYPES wpdiarestart LIKE emutilize-wpdiarestr.
  TYPES wpnondiarestart LIKE emutilize-wpnodiares.
  TYPES END OF ts_em.
  DATA ls_em TYPE ts_em.
  TYPES BEGIN OF ts_eg.
  TYPES totalsize TYPE i.
  TYPES usedsize TYPE i.
  TYPES END OF ts_eg.
  DATA ls_eg TYPE ts_eg.
  TYPES BEGIN OF ts_shm.
  TYPES used TYPE shm_memory_size.
  TYPES free TYPE shm_memory_size.
  TYPES displacable TYPE shm_memory_size.
  TYPES END OF ts_shm.
  DATA ls_shm TYPE ts_shm.
  CALL 'ThWpInfo' ID 'OPCODE' FIELD lc_opcode_25
    ID 'DIAWP' FIELD ls_proccess-dia
    ID 'FREE_DIAWP' FIELD ls_proccess-dia_free
    ID 'VBWP' FIELD  ls_proccess-upd
    ID 'FREE_VBWP' FIELD ls_proccess-upd_free
    ID 'BTCWP' FIELD ls_proccess-btc
    ID 'FREE_BTCWP' FIELD ls_proccess-btc_free
    ID 'SPOWP' FIELD ls_proccess-spo
    ID 'FREE_SPOWP' FIELD ls_proccess-spo_free
    ID 'VB2WP' FIELD ls_proccess-upd2
    ID 'FREE_VB2WP' FIELD ls_proccess-upd2_free.
  CALL 'ThSysInfo' ID 'OPCODE' FIELD lc_opcode_67
    ID 'SERVER' FIELD lv_server
    ID 'RESET_QUEUE_PEAK' FIELD 0
    ID 'QUEUE_INFO' FIELD lt_queue[].
  LOOP AT lt_queue[]
    ASSIGNING FIELD-SYMBOL(<ls_queue>).
    CASE <ls_queue>-req_type.
      WHEN dp_rq_stat_diawp.
        ls_proccess-dia_queue = <ls_queue>-now.
      WHEN dp_rq_stat_updwp.
        ls_proccess-upd_queue = <ls_queue>-now.
      WHEN dp_rq_stat_btcwp.
        ls_proccess-btc_queue = <ls_queue>-now.
      WHEN dp_rq_stat_spowp.
        ls_proccess-spo_queue = <ls_queue>-now.
      WHEN dp_rq_stat_upd2wp.
        ls_proccess-upd2_queue = <ls_queue>-now.
    ENDCASE.
  ENDLOOP.
  SELECT COUNT(*)
    FROM tsp01
    INTO @ls_print-print
    WHERE tsp01~rqpjreq GT 0.
  SELECT COUNT(*)
    FROM tsp01
    INTO @DATA(lv_print_job_all).
  ls_print-no_print = lv_print_job_all - ls_print-print.
  CALL 'EsMemMgt'
     ID 'OPCODE'            FIELD 101
     ID 'blockSizeKB'       FIELD ls_em-blocksizekb
     ID 'ExistingSlots'     FIELD ls_em-slotsexisting
     ID 'UsedSlots'         FIELD ls_em-slotsused
     ID 'AllocatedSlots'    FIELD ls_em-slotsallocated
     ID 'AttachedSlots'     FIELD ls_em-slotsattached
     ID 'heapUsedSum'       FIELD ls_em-heapusedsum
     ID 'privWpNo'          FIELD ls_em-privwpno
     ID 'emSlotsUsed'       FIELD ls_em-emslotsused
     ID 'emSlotsUsedPeak'   FIELD ls_em-emslotsusedpeak
     ID 'emSlotsTotal'      FIELD ls_em-emslotstotal
     ID 'heapUsedSumKB'     FIELD ls_em-heapusedsumkb
     ID 'heapUsedSumPeakKB' FIELD ls_em-heapusedsumpeakkb
     ID 'WpDiaRestart'      FIELD ls_em-wpdiarestart
     ID 'WpNonDiaRestart'   FIELD ls_em-wpnondiarestart.
  CALL 'EG_MEM_MGT'
   ID 'OPCODE' FIELD 1
   ID 'totalSizeKB' FIELD ls_eg-totalsize
   ID 'usedSizeKB' FIELD ls_eg-usedsize.
  cl_shm_utilities=>get_current_usage( IMPORTING used = ls_shm-used
                                                 free = ls_shm-free
                                                 displacable = ls_shm-displacable ).
  CALL FUNCTION 'GET_CPU_ALL'
    TABLES
      tf_cpu_all    = lt_cpu_all[]
    EXCEPTIONS
      error_message = 0
      OTHERS        = 0.
  ASSIGN  lt_cpu_all[ 1 ] TO FIELD-SYMBOL(<ls_cpu_all>).
  IF sy-subrc EQ 0.
    lv_cpu_user_utilization = <ls_cpu_all>-usr_total.
    lv_cpu_system_utilization = <ls_cpu_all>-sys_total.
    lv_cpu_wait = <ls_cpu_all>-wait_true.
    lv_cpu_1_minload_average = <ls_cpu_all>-load1_avg.
    lv_cpu_5_minload_average = <ls_cpu_all>-load5_avg.
    lv_cpu_15_minload_average = <ls_cpu_all>-load15_avg.
    lv_cpu_interrupts = <ls_cpu_all>-int_sec.
    lv_cpu_system_calls = <ls_cpu_all>-sysc_sec.
    lv_cpu_context_switches = <ls_cpu_all>-cs_sec.
  ENDIF.

  LOOP AT t_parameters[]
    ASSIGNING FIELD-SYMBOL(<ls_parameters>).
    CASE <ls_parameters>-name.
      WHEN 'ExtendedMemory'.
        <ls_parameters>-value = ls_em-slotsexisting * ls_em-blocksizekb / 1024.
      WHEN 'ExtendedMemoryUse'.
        <ls_parameters>-value = ls_em-slotsallocated * ls_em-blocksizekb / 1024.
      WHEN 'SharedMemory'.
        <ls_parameters>-value = ( ls_shm-used + ls_shm-free ) / 1048576.
      WHEN 'SharedMemoryUse'.
        <ls_parameters>-value = ls_shm-used / 1048576.
      WHEN 'ExtendedGlobalMemory'.
        <ls_parameters>-value = ls_eg-totalsize / 1024.
      WHEN 'ExtendedGlobalMemoryUse'.
        <ls_parameters>-value = ls_eg-usedsize / 1024.
      WHEN 'HeapMemory'.
        <ls_parameters>-value = ls_em-heapusedsumkb / 1024.
      WHEN 'HeapMemoryUse'.
        <ls_parameters>-value = ls_em-heapusedsum / 1024.
      WHEN 'CPUUserUtilization'.
        <ls_parameters>-value = lv_cpu_user_utilization.
      WHEN 'CPUSystemUtilization'.
        <ls_parameters>-value = lv_cpu_system_utilization.
      WHEN 'CPUWait'.
        <ls_parameters>-value = lv_cpu_wait.
      WHEN 'CPU1MinLoadAverage'.
        <ls_parameters>-value = lv_cpu_1_minload_average.
      WHEN 'CPU5MinLoadAverage'.
        <ls_parameters>-value = lv_cpu_5_minload_average.
      WHEN 'CPU15MinLoadAverage'.
        <ls_parameters>-value = lv_cpu_15_minload_average.
      WHEN 'CPUContextSwitches'.
        <ls_parameters>-value = lv_cpu_context_switches.
      WHEN 'CPUSystemCalls'.
        <ls_parameters>-value = lv_cpu_system_calls.
      WHEN 'CPUInterrupts'.
        <ls_parameters>-value = lv_cpu_interrupts.
      WHEN 'DIA'.
        <ls_parameters>-value = ls_proccess-dia.
      WHEN 'DIAInUse'.
        <ls_parameters>-value = ls_proccess-dia - ls_proccess-dia_free.
      WHEN 'DIAFree'.
        <ls_parameters>-value = ls_proccess-dia_free.
      WHEN 'DIAQueue'.
        <ls_parameters>-value = ls_proccess-dia_queue.
      WHEN 'UPD'.
        <ls_parameters>-value = ls_proccess-upd.
      WHEN 'UPDInUse'.
        <ls_parameters>-value = ls_proccess-upd - ls_proccess-upd_free.
      WHEN 'UPDFree'.
        <ls_parameters>-value = ls_proccess-upd_free.
      WHEN 'UPDQueue'.
        <ls_parameters>-value = ls_proccess-upd_queue.
      WHEN 'UPD2'.
        <ls_parameters>-value = ls_proccess-upd2.
      WHEN 'UPD2InUse'.
        <ls_parameters>-value = ls_proccess-upd2 - ls_proccess-upd2_free.
      WHEN 'UPD2Free'.
        <ls_parameters>-value = ls_proccess-upd2_free.
      WHEN 'UPD2Queue'.
        <ls_parameters>-value = ls_proccess-upd2_queue.
      WHEN 'BTC'.
        <ls_parameters>-value = ls_proccess-btc.
      WHEN 'BTCInUse'.
        <ls_parameters>-value = ls_proccess-btc - ls_proccess-btc_free.
      WHEN 'BTCFree'.
        <ls_parameters>-value = ls_proccess-btc_free.
      WHEN 'BTCQueue'.
        <ls_parameters>-value = ls_proccess-btc_queue.
      WHEN 'SPO'.
        <ls_parameters>-value = ls_proccess-spo.
      WHEN 'SPOInUse'.
        <ls_parameters>-value = ls_proccess-spo - ls_proccess-spo_free.
      WHEN 'SPOFree'.
        <ls_parameters>-value = ls_proccess-spo_free.
      WHEN 'SPOQueue'.
        <ls_parameters>-value = ls_proccess-spo_queue.
      WHEN 'JobsNoPrint'.
        <ls_parameters>-value = ls_print-no_print.
      WHEN 'JobsWait'.
        <ls_parameters>-value = ls_print-print.
    ENDCASE.
  ENDLOOP.

ENDFUNCTION.
