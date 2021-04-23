FUNCTION zabapccms_get_gw_data.
*"----------------------------------------------------------------------
*"*"Локальный интерфейс:
*"  TABLES
*"      T_PARAMETERS TYPE  ZTTCCMS_PARAMETERS_VALUE
*"----------------------------------------------------------------------

  DATA: lt_tst      TYPE RANGE OF timestamp,
        lt_gwdata   TYPE TABLE OF /iwfnd/l_met_dat,
        lv_tst      TYPE timestamp,
        lv_main_id  TYPE /iwfnd/met_guid_main,
        lv_gwcount  TYPE i,
        lv_gwpcount TYPE i,
        lv_gwtime   TYPE /iwfnd/met_xml_size_large,
        lv_gwptime  TYPE /iwfnd/met_xml_size_large.

  FIELD-SYMBOLS: <ls_gwdata> TYPE /iwfnd/l_met_dat.

  GET TIME STAMP FIELD lv_tst.

  lt_tst = VALUE #( ( sign = wmegc_sign_inclusive
                    option = wmegc_option_bt
                       low = cl_abap_tstmp=>subtractsecs( tstmp = lv_tst secs = 60 )
                      high = lv_tst ) ).

  SELECT id duration request_address
    FROM /iwfnd/l_met_dat
    INTO CORRESPONDING FIELDS OF TABLE lt_gwdata
   WHERE timestamp IN lt_tst.

  LOOP AT lt_gwdata ASSIGNING <ls_gwdata>.
    IF <ls_gwdata>-request_address = '/sap/opu/odata/sap/ZEWM_NWG_TERMINAL_SRV/MainDataSet?&$expand=&$format=json'.
      ADD <ls_gwdata>-duration TO lv_gwptime.
      ADD 1 TO lv_gwpcount.
    ENDIF.
    ADD <ls_gwdata>-duration TO lv_gwtime.
    ADD 1 TO lv_gwcount.
  ENDLOOP.

  lv_gwtime = lv_gwtime / lv_gwcount / 1000.
  lv_gwptime = lv_gwptime / lv_gwpcount / 1000.

  LOOP AT t_parameters[] ASSIGNING FIELD-SYMBOL(<ls_parameters>).
    CASE <ls_parameters>-name.
      WHEN 'GWCount'.
        <ls_parameters>-value = lv_gwcount.
      WHEN 'GWAverageTime'.
        <ls_parameters>-value = lv_gwtime.
      WHEN 'GWAveragePingTime'.
        <ls_parameters>-value = lv_gwptime.
    ENDCASE.
  ENDLOOP.

ENDFUNCTION.
