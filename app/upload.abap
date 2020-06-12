CLASS zcl_rh_file_manager DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_http_service_extension .


  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA: lv_tablename TYPE string.
    DATA: lv_filename TYPE string.
    DATA: lv_fileext TYPE string.
    DATA: lv_content TYPE string.

    METHODS: parse_body IMPORTING im_content  TYPE string.
    METHODS: get_tablename RETURNING VALUE(r_tablename) TYPE string.
    METHODS: get_content RETURNING VALUE(r_content) TYPE string.
    METHODS: get_filename RETURNING VALUE(r_filename) TYPE string.
    METHODS: get_fileext RETURNING VALUE(r_fileext) TYPE string.
    METHODS: load_table.
    METHODS: get_html RETURNING VALUE(html) TYPE string.

ENDCLASS.



CLASS zcl_rh_file_manager IMPLEMENTATION.


  METHOD if_http_service_extension~handle_request.

    CASE request->get_method(  ).
      WHEN CONV string( if_web_http_client=>get ).

*        response->set_text( `<form action="upload.php" method="post" enctype="multipart/form-data"> Select image to upload:  <input type="file" name="fileToUpload" id="fileToUpload">` &&
*                            ` Enter table to upload to: <input type="field" name="tablename" id="tablename">   <input type="submit" value="Upload File" name="submit"> </form>'` ).
        DATA(sap_table_request) = request->get_header_field( 'sap-table-request' ).
        IF sap_table_request IS INITIAL.
          response->set_text( get_html(   ) ).
        ELSE.
          DATA(name_filter) = xco_cp_abap_repository=>object_name->get_filter( xco_cp_abap_sql=>constraint->contains_pattern(  sap_table_request && '%' )  ).
          DATA(objects) = xco_cp_abap_repository=>objects->tabl->where( VALUE #(
                              ( name_filter ) ) )->in( xco_cp_abap=>repository  )->get(  ).

          data res type string.
          res = `[`.

          loop at objects INTO data(object).
            res &&= |\{ "TABLE_NAME": "{ object->name }" \}|.
            if sy-tabix ne lines( objects ).
              res &&= `,`.
            endif.
          ENDLOOP.
          res &&= `]`.
          response->set_text( res ).
        ENDIF.

      WHEN CONV string( if_web_http_client=>post ).

        me->parse_body( im_content = request->get_text(  ) ).

        DATA(formfields) = request->get_form_fields( ).
        DATA(headers) = request->get_header_fields( ).

        lv_tablename = request->get_form_field(  `filetoupload-data` ).
        IF lv_tablename IS INITIAL.
          response->set_status( i_code = if_web_http_status=>bad_request i_reason = |Table name { lv_tablename } not valid or does not exist| ).
          response->set_text( |Table name { lv_tablename } not valid or does not exist| ).
          RETURN.
        ENDIF.


        IF me->get_fileext( ) <> `json`.
*          and me->get_fileext( ) <> `txt`
*          and me->get_fileext( ) <> 'csv'.
          response->set_status( i_code = if_web_http_status=>bad_request i_reason = `File type not supported` ).
          response->set_text( `File type not supported` ).
          RETURN.
        ENDIF.

        me->load_table(  ).
        response->set_status( i_code = if_web_http_status=>ok i_reason = `Table updated successfully` ).
        response->set_text( `Table updated successfully` ).
*        response->set_text( me->get_content( ) ).

    ENDCASE.

  ENDMETHOD.

  METHOD parse_body.

* what a freakin mess...
    SPLIT im_content AT cl_abap_char_utilities=>cr_lf INTO TABLE DATA(lt_body).

    READ TABLE lt_body REFERENCE INTO DATA(lr_body) INDEX 2.
    IF sy-subrc = 0.

      SPLIT lr_body->* AT ';' INTO TABLE DATA(lt_contentdis).

      READ TABLE lt_contentdis REFERENCE INTO DATA(lr_contentdis) INDEX 3.
      IF sy-subrc = 0.
        SPLIT lr_contentdis->* AT '=' INTO DATA(lv_fn) lv_filename.
        REPLACE ALL OCCURRENCES OF `"` IN lv_filename WITH space.
        CONDENSE lv_filename NO-GAPS.
        SPLIT lv_filename AT '.' INTO lv_filename lv_fileext.
      ENDIF.

    ENDIF.

    DELETE lt_body FROM 1 TO 4.  " Get rid of the first 4 lines of the body
    DELETE lt_body FROM ( lines( lt_body ) - 8 ) TO lines( lt_body ).  " get rid of the last 9 lines of the body

    LOOP AT lt_body REFERENCE INTO lr_body.
      CASE lv_fileext.
        WHEN `json`.
          lv_content = lv_content && lr_body->*.
        WHEN OTHERS.
          lv_content = lv_content && lr_body->* && cl_abap_char_utilities=>cr_lf.
      ENDCASE.
    ENDLOOP.


  ENDMETHOD.

  METHOD load_table.

    DATA: lr_dynamic_table TYPE REF TO data.
    FIELD-SYMBOLS: <lt_table_structure> TYPE table.

    CREATE DATA lr_dynamic_table TYPE TABLE OF (lv_tablename).
    ASSIGN lr_dynamic_table->* TO <lt_table_structure>.

    /ui2/cl_json=>deserialize( EXPORTING json = lv_content
                               pretty_name = /ui2/cl_json=>pretty_mode-none
                               CHANGING data = <lt_table_structure> ).

    DELETE FROM (lv_tablename).

    INSERT (lv_tablename) FROM TABLE @<lt_table_structure>.

  ENDMETHOD.

  METHOD get_tablename.
    r_tablename = lv_tablename.
  ENDMETHOD.

  METHOD get_content.
    r_content = lv_content.
  ENDMETHOD.
  METHOD get_filename.
    r_filename = lv_filename.
  ENDMETHOD.

  METHOD get_fileext.
    r_fileext = lv_fileext.
  ENDMETHOD.

  METHOD get_html.
    html =
    |<!DOCTYPE HTML> \n| &&
     |<html> \n| &&
     |<head> \n| &&
     |    <meta http-equiv="X-UA-Compatible" content="IE=edge"> \n| &&
     |    <meta http-equiv='Content-Type' content='text/html;charset=UTF-8' /> \n| &&
     |    <title>ABAP File Uploader</title> \n| &&
     |    <script id="sap-ui-bootstrap" src="https://sapui5.hana.ondemand.com/resources/sap-ui-core.js" \n| &&
     |        data-sap-ui-theme="sap_fiori_3_dark" data-sap-ui-xx-bindingSyntax="complex" data-sap-ui-compatVersion="edge" \n| &&
     |        data-sap-ui-async="true"> \n| &&
     |    </script> \n| &&
     |    <script> \n| &&
     |        sap.ui.require(['sap/ui/core/Core'], (oCore, ) => \{ \n| &&
     | \n| &&
     |            sap.ui.getCore().loadLibrary("sap.f", \{ \n| &&
     |                async: true \n| &&
     |            \}).then(() => \{ \n| &&
     |                let shell = new sap.f.ShellBar("shell") \n| &&
     |                shell.setTitle("ABAP File Uploader") \n| &&
     |                shell.setShowCopilot(true) \n| &&
     |                shell.setShowSearch(true) \n| &&
     |                shell.setShowNotifications(true) \n| &&
     |                shell.setShowProductSwitcher(true) \n| &&
     |                shell.placeAt("uiArea") \n| &&
     |                sap.ui.getCore().loadLibrary("sap.ui.layout", \{ \n| &&
     |                    async: true \n| &&
     |                \}).then(() => \{ \n| &&
     |                    let layout = new sap.ui.layout.VerticalLayout("layout") \n| &&
     |                    layout.placeAt("uiArea") \n| &&
     |                    let line2 = new sap.ui.layout.HorizontalLayout("line2") \n| &&
     |                    sap.ui.getCore().loadLibrary("sap.m", \{ \n| &&
     |                        async: true \n| &&
     |                    \}).then(() => \{\}) \n| &&
     |                    let button = new sap.m.Button("button") \n| &&
     |                    button.setText("Upload File") \n| &&
     |                    button.attachPress(function () \{ \n| &&
     |                        let oFileUploader = oCore.byId("fileToUpload") \n| &&
     |                        if (!oFileUploader.getValue()) \{ \n| &&
     |                            sap.m.MessageToast.show("Choose a file first") \n| &&
     |                            return \n| &&
     |                        \} \n| &&
     |                        let oInput = oCore.byId("tablename") \n| &&
     |                        if (!oInput.getValue())\{ \n| &&
     |                            sap.m.MessageToast.show("Target Table is Required") \n| &&
     |                            return \n| &&
     |                        \} \n| &&
     |                       let param = oCore.byId("uploadParam") \n| &&
     |                       param.setValue( oInput.getValue() ) \n| &&
     |                       oFileUploader.getParameters() \n| &&
     |                       oFileUploader.setAdditionalData(oInput.getValue()) \n| &&
     |                       oFileUploader.upload() \n| &&
     |                    \}) \n| &&
     |                    let input = new sap.m.Input("tablename") \n| &&
     |                    input.placeAt("layout") \n| &&
     |                    input.setRequired(true) \n| &&
     |                    input.setWidth("600px") \n| &&
     |                    input.setPlaceholder("Target ABAP Table") \n| &&
     |                    input.setShowSuggestion(true) \n| &&
     |                    input.attachSuggest(function (oEvent)\{ \n| &&
     |                      jQuery.ajax(\{headers: \{ "sap-table-request": oEvent.getParameter("suggestValue") \},error: function(oErr)\{ alert( JSON.stringify(oErr))\}, timeout: 30000, method:"GET",dataType: "json",success: function(myJSON) \{ \n| &&
  "   |                      alert( 'test' ) \n| &&
     |                      let input = oCore.byId("tablename") \n | &&
     |                      input.destroySuggestionItems() \n | &&
     |                      for (var i = 0; i < myJSON.length; i++) \{ \n | &&
     |                          input.addSuggestionItem(new sap.ui.core.Item(\{ \n| &&
     |                              text: myJSON[i].TABLE_NAME  \n| &&
     |                          \})); \n| &&
     |                      \} \n| &&
     |                    \} \}) \n| &&
     |                    \}) \n| &&
     |                    line2.placeAt("layout") \n| &&
     |                    sap.ui.getCore().loadLibrary("sap.ui.unified", \{ \n| &&
     |                        async: true \n| &&
     |                    \}).then(() => \{ \n| &&
     |                        var fileUploader = new sap.ui.unified.FileUploader( \n| &&
     |                            "fileToUpload") \n| &&
     |                        fileUploader.setFileType("json") \n| &&
     |                        fileUploader.setWidth("400px") \n| &&
     |                        let param = new sap.ui.unified.FileUploaderParameter("uploadParam") \n| &&
     |                        param.setName("tablename") \n| &&
     |                        fileUploader.addParameter(param) \n| &&
     |                        fileUploader.placeAt("line2") \n| &&
     |                        button.placeAt("line2") \n| &&
     |                        fileUploader.setPlaceholder( \n| &&
     |                            "Choose File for Upload...") \n| &&
     |                        fileUploader.attachUploadComplete(function (oEvent) \{ \n| &&
     |                           alert(oEvent.getParameters().response)  \n| &&
     |                       \})   \n| &&
     | \n| &&
     |                    \}) \n| &&
     |                \}) \n| &&
     |            \}) \n| &&
     |        \}) \n| &&
     |    </script> \n| &&
     |</head> \n| &&
     |<body class="sapUiBody"> \n| &&
     |    <div id="uiArea"></div> \n| &&
     |</body> \n| &&
     | \n| &&
     |</html> |.
  ENDMETHOD.

ENDCLASS.