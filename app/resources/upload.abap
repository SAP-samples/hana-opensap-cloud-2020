class ZCL_A4C_FILE_UPLOADER definition
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_http_service_extension .

  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA: tablename TYPE string.
    DATA: filename TYPE string.
    DATA: fileext TYPE string.
    DATA: data TYPE string.

    METHODS: parse_request IMPORTING request_content  TYPE string.
    METHODS: get_html RETURNING VALUE(ui_html) TYPE string.

ENDCLASS.

CLASS ZCL_A4C_FILE_UPLOADER  IMPLEMENTATION.

  METHOD if_http_service_extension~handle_request.

    CASE request->get_method(  ).
      WHEN CONV string( if_web_http_client=>get ).

        DATA(sap_table_request) = request->get_header_field( 'sap-table-request' ).
        IF sap_table_request IS INITIAL.
          response->set_text( get_html(   ) ).
        ELSE.
          DATA(name_filter) = xco_cp_abap_repository=>object_name->get_filter(
                               xco_cp_abap_sql=>constraint->contains_pattern( to_upper( sap_table_request ) && '%' )  ).
          DATA(objects) = xco_cp_abap_repository=>objects->tabl->where( VALUE #(
                              ( name_filter ) ) )->in( xco_cp_abap=>repository  )->get(  ).

          DATA res TYPE string.
          res = `[`.
          LOOP AT objects INTO DATA(object).
            res &&= |\{ "TABLE_NAME": "{ object->name }" \}|.
            IF sy-tabix NE lines( objects ).
              res &&= `,`.
            ENDIF.
          ENDLOOP.
          res &&= `]`.
          response->set_text( res ).
        ENDIF.

      WHEN CONV string( if_web_http_client=>post ).

        me->parse_request( request->get_text(  ) ).

* Unpack input field values such as tablename, etc.
        DATA(lv_ui_data) = request->get_form_field(  `filetoupload-data` ).
        DATA: lr_ui_data TYPE REF TO data.
        FIELD-SYMBOLS: <fs_data>  TYPE data,
                       <fs_field> TYPE any.

        lr_ui_data = /ui2/cl_json=>generate( json = lv_ui_data ).
        IF lr_ui_data IS BOUND.
          ASSIGN lr_ui_data->* TO <fs_data>.
          ASSIGN COMPONENT `TABLENAME` OF STRUCTURE <fs_data> TO <fs_field>.
          IF <fs_field> IS ASSIGNED.
            ASSIGN <fs_field>->* TO <fs_data>.
            tablename = <fs_data>.
          ENDIF.
        ENDIF.

* Check table name is valid.
        IF xco_cp_abap_repository=>object->tabl->database_table->for(
                             iv_name =  CONV #( tablename ) )->exists(  ) = abap_false
          OR tablename IS INITIAL.
          response->set_status( i_code = if_web_http_status=>bad_request
                                i_reason = |Table name { tablename } not valid or does not exist| ).
          response->set_text( |Table name { tablename } not valid or does not exist| ).
          RETURN.
        ENDIF.

* Check file extension is valid, only json today.
        IF fileext <> `json`.
          response->set_status( i_code = if_web_http_status=>bad_request
                                i_reason = `File type not supported` ).
          response->set_text( `File type not supported` ).
          RETURN.
        ENDIF.

* Still here?  Load the data to the table via dynamic internal table
        DATA: dynamic_table TYPE REF TO data.
        FIELD-SYMBOLS: <table_structure> TYPE table.

        TRY.
            CREATE DATA dynamic_table TYPE TABLE OF (tablename).
            ASSIGN dynamic_table->* TO <table_structure>.
          CATCH cx_sy_create_data_error.
        ENDTRY.

        /ui2/cl_json=>deserialize( EXPORTING json = data
                                   pretty_name = /ui2/cl_json=>pretty_mode-none
                                   CHANGING data = <table_structure> ).

        DELETE FROM (tablename).

        INSERT (tablename) FROM TABLE @<table_structure>.
        IF sy-subrc = 0.
          response->set_status( i_code = if_web_http_status=>ok
                                i_reason = `Table updated successfully` ).
          response->set_text( `Table updated successfully` ).
        ENDIF.

    ENDCASE.

  ENDMETHOD.

  METHOD parse_request.

* the request comes in with metadata around the actual file data,
* extract the filename and fileext from this metadata as well as the raw file data.
    SPLIT request_content AT cl_abap_char_utilities=>cr_lf INTO TABLE DATA(content).
    READ TABLE content REFERENCE INTO DATA(content_item) INDEX 2.
    IF sy-subrc = 0.

      SPLIT content_item->* AT ';' INTO TABLE DATA(content_dis).
      READ TABLE content_dis REFERENCE INTO DATA(content_dis_item) INDEX 3.
      IF sy-subrc = 0.
        SPLIT content_dis_item->* AT '=' INTO DATA(fn) filename.
        REPLACE ALL OCCURRENCES OF `"` IN filename WITH space.
        CONDENSE filename NO-GAPS.
        SPLIT filename AT '.' INTO filename fileext.
      ENDIF.

    ENDIF.

    DELETE content FROM 1 TO 4.  " Get rid of the first 4 lines
    DELETE content FROM ( lines( content ) - 8 ) TO lines( content ).  " get rid of the last 9 lines

    LOOP AT content REFERENCE INTO content_item.  " put it all back together again humpdy dumpdy....
          data = data && content_item->*.
    ENDLOOP.

  ENDMETHOD.


  METHOD get_html.
    ui_html =
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
     |                    let line3 = new sap.ui.layout.HorizontalLayout("line3") \n| &&
     |                    let line4 = new sap.ui.layout.HorizontalLayout("line4") \n| &&
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
     |                        let oGroup = oCore.byId("grpDataOptions") \n| &&
     |                        if (!oInput.getValue())\{ \n| &&
     |                            sap.m.MessageToast.show("Target Table is Required") \n| &&
     |                            return \n| &&
     |                        \} \n| &&
     |                       let param = oCore.byId("uploadParam") \n| &&
     |                       param.setValue( oInput.getValue() ) \n| &&
     |                       oFileUploader.getParameters() \n| &&
     |                       oFileUploader.setAdditionalData(JSON.stringify(\{tablename: oInput.getValue(), \n| &&
     |                           dataOption: oGroup.getSelectedIndex() \})) \n| &&
     |                       oFileUploader.upload() \n| &&
     |                    \}) \n| &&
     |                    let input = new sap.m.Input("tablename") \n| &&
     |                    input.placeAt("layout") \n| &&
     |                    input.setRequired(true) \n| &&
     |                    input.setWidth("600px") \n| &&
     |                    input.setPlaceholder("Target ABAP Table") \n| &&
     |                    input.setShowSuggestion(true) \n| &&
     |                    input.attachSuggest(function (oEvent)\{ \n| &&
     |                      jQuery.ajax(\{headers: \{ "sap-table-request": oEvent.getParameter("suggestValue") \n | &&
     |                          \}, \n| &&
     |                         error: function(oErr)\{ alert( JSON.stringify(oErr))\}, timeout: 30000, method:"GET",dataType: "json",success: function(myJSON) \{ \n| &&
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
     |                    line3.placeAt("layout") \n| &&
     |                    line4.placeAt("layout") \n| &&
     |                    let groupDataOptions = new sap.m.RadioButtonGroup("grpDataOptions") \n| &&
     |                    let lblGroupDataOptions = new sap.m.Label("lblDataOptions") \n| &&
     |                    lblGroupDataOptions.setLabelFor(groupDataOptions) \n| &&
     |                    lblGroupDataOptions.setText("Data Upload Options") \n| &&
     |                    lblGroupDataOptions.placeAt("line3") \n| &&
     |                    groupDataOptions.placeAt("line4") \n| &&
     |                    rbAppend = new sap.m.RadioButton("rbAppend") \n| &&
     |                    rbReplace = new sap.m.RadioButton("rbReplace") \n| &&
     |                    rbAppend.setText("Append") \n| &&
     |                    rbReplace.setText("Replace") \n| &&
     |                    groupDataOptions.addButton(rbAppend) \n| &&
     |                    groupDataOptions.addButton(rbReplace) \n| &&
     |                    rbAppend.setGroupName("grpDataOptions") \n| &&
     |                    rbReplace.setGroupName("grpDataOptions") \n| &&
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