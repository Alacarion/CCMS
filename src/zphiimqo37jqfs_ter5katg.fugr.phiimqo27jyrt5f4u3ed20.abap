FUNCTION phiimqo27jyrt5f4u3ed20.
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
  DATA lv_extended_memory TYPE i.
  DATA lv_extended_memory_use TYPE i.
  DATA lt_cpu_all TYPE STANDARD TABLE OF cpu_all.
  DATA lt_mem_all TYPE STANDARD TABLE OF mem_all.
  CALL FUNCTION 'GET_CPU_ALL'
    EXPORTING
      local_remote        = 'WSHOST'
      logical_destination = 'SAPOSCOL.ALFAWP01.99'
    TABLES
      tf_cpu_all          = lt_cpu_all[]
    EXCEPTIONS
      error_message       = 0
      OTHERS              = 0.
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
  CALL FUNCTION 'GET_MEM_ALL'
    EXPORTING
      local_remote        = 'WSHOST'
      logical_destination = 'SAPOSCOL.ALFAWP01.99'
    TABLES
      tf_mem_all          = lt_mem_all[]
    EXCEPTIONS
      error_message       = 0
      OTHERS              = 0.
  ASSIGN  lt_mem_all[ 1 ] TO FIELD-SYMBOL(<ls_mem_all>).
  IF sy-subrc EQ 0.
    lv_extended_memory = <ls_mem_all>-phys_mem.
    lv_extended_memory_use = <ls_mem_all>-phys_mem - <ls_mem_all>-free_mem.
  ENDIF.
  LOOP AT t_parameters[]
    ASSIGNING FIELD-SYMBOL(<ls_parameters>).
    CASE <ls_parameters>-name.
      WHEN 'ExtendedMemory'.
        <ls_parameters>-value = lv_extended_memory / 1024.
      WHEN 'ExtendedMemoryUse'.
        <ls_parameters>-value = lv_extended_memory_use / 1024.
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
    ENDCASE.
  ENDLOOP.
ENDFUNCTION.
