<cflock name="#CREATEUUID()#" timeout="20">
    <cftransaction>
        <cfquery name="ADD_MAIN_MENU_SETTINGS" datasource="#DSN#">
            INSERT INTO MAIN_MENU_SETTINGS 
                (
                    IS_ACTIVE,
                    IS_PUBLISH,
					SITE_TYPE,
                    MENU_NAME,
                    RECORD_DATE,
                    RECORD_EMP,
                    RECORD_IP,
                    <cfif isDefined('attributes.site_type') and attributes.site_type eq 4>
                        GENERAL_ALIGN,
                        GENERAL_WIDTH_TYPE,
                        GENERAL_WIDTH,
                        MAIN_HEIGHT,
                        SECOND_HEIGHT,
                        FOOTER_HEIGHT,
                    </cfif>
                    OUR_COMPANY_ID
                ) 
                VALUES 
                (
                    <cfif isdefined("attributes.is_active")>1<cfelse>0</cfif>,
                    <cfif isdefined("attributes.is_publish")>1<cfelse>0</cfif>,
                    <cfif isDefined('attributes.site_type') and len(attributes.site_type)>#attributes.site_type#<cfelse>NULL</cfif>,
                    #sql_unicode()#'#attributes.menu_name#',
                    #NOW()#,
                    #session.ep.userid#,
                    '#CGI.REMOTE_ADDR#',
                    <cfif isDefined('attributes.site_type') and attributes.site_type eq 4>
                        'left',
                        'px',
                        320,
                        75,
                        75,
                        75,
                    </cfif>
                    #session.ep.company_id#
                )
        </cfquery>
        <cfquery name="GET_MAX_MENU" datasource="#DSN#" maxrows="1">
            SELECT MAX(MENU_ID) MENU_ID FROM MAIN_MENU_SETTINGS
        </cfquery>
        <cfif isDefined('attributes.site_type') and attributes.site_type eq 4>
            <!--- PDA Secildiginde Sayfa Ilk Yuklendiginde Standart Pda Linkleri ve Xmller Eklenir --->
            <cffile action="read" file="#download_folder#admin_tools#dir_seperator#xml#dir_seperator#setup_pda_menu.xml" variable="XmlDosyam" charset="utf-8">
            <cfset Dosyam = XmlParse(XmlDosyam)>
            <cfset XmlDizi = Dosyam.Pda_Menu_Standart.XmlChildren>
            <cfset XmlCount = ArrayLen(XmlDizi)>
            
            <cfif Len(XmlCount) and XmlCount gt 0>
                <cfloop from="1" to= "#XmlCount#" index="x">
                    <cfset Faction_ = ListLast(XmlDizi[x].Selected_Link.XmlText,".")>				
                    <!--- Resim Ekleniyor --->
                    <cfset upload_folder_new = "#upload_folder#settings#dir_seperator#">
                    <cfset Image_Name = XmlDizi[x].Link_Image.XmlText>
                    <cfset File_Src = "#GetDirectoryFromPath(GetCurrentTemplatePath())#..#dir_seperator#..#dir_seperator#images#dir_seperator#pda#dir_seperator##Image_Name#"><!--- images#dir_seperator#pda#dir_seperator# --->
                    <cffile action="copy" source="#File_Src#" destination = "#upload_folder_new##Image_Name#">
                    <cfset File_Name_New = '#Image_Name#'>
                    <!--- //Resim Ekleniyor --->
                    
    
                    <cfquery name="ADD_MAIN_MENU_SELECTS" datasource="#DSN#">
                        INSERT INTO 
                            MAIN_MENU_SELECTS
                            (
                                MENU_ID,
                                ORDER_NO,
                                SELECTED_LINK,
                                LINK_NAME,
                                LINK_IMAGE,
                                LINK_IMAGE_SERVER_ID,
                                LINK_NAME_TYPE,
                                LINK_TYPE,
                                LINK_AREA,
                                IS_SESSION,
                                LOGIN_CONTROL
                            )
                            VALUES
                            (
                                #Get_Max_Menu.Menu_Id#,
                                #XmlDizi[x].Order_No.XmlText#,
                                '#XmlDizi[x].Selected_Link.XmlText#',
                                '#XmlDizi[x].Link_Name.XmlText#',
                                '#File_Name_New#',<!--- #XmlDizi[x].Link_Image.XmlText# --->
                                #XmlDizi[x].Link_Image_Server_Id.XmlText#,
                                #XmlDizi[x].Link_Name_Type.XmlText#,
                                #XmlDizi[x].Link_Type.XmlText#,
                                #XmlDizi[x].Link_Area.XmlText#,
                                #XmlDizi[x].Is_Session.XmlText#,
                                #XmlDizi[x].Login_Control.XmlText#
                            )
                    </cfquery>
                    <cfquery name="ADD_MAIN_SITE_LAYOUTS" datasource="#DSN#">
                        INSERT INTO
                            MAIN_SITE_LAYOUTS
                            (
                                MENU_ID,
                                FACTION,
                                LEFT_WIDTH,
                                RIGHT_WIDTH,
                                CENTER_WIDTH,
                                MARGIN,
                                RECORD_EMP,
                                RECORD_DATE,
                                RECORD_IP
                            )
                            VALUES
                            (
                                #Get_Max_Menu.Menu_Id#,
                                '#Faction_#',
                                0,
                                0,
                                0,
                                0,
                                #Session.Ep.UserId#,
                                #Now()#,
                                '#Cgi.Remote_Addr#'
                            )
                    </cfquery>
                    <cfquery name="ADD_MAIN_SITE_LAYOUT_SELECTS" datasource="#DSN#">
                        INSERT INTO
                            MAIN_SITE_LAYOUTS_SELECTS
                            (
                                MENU_ID,
                                DESIGN_ID,
                                ORDER_NUMBER,
                                OBJECT_POSITION,
                                OBJECT_NAME,
                                OBJECT_FOLDER,
                                OBJECT_FILE_NAME,
                                FACTION
                            )
                            VALUES
                            (
                                #Get_Max_Menu.Menu_Id#,
                                1,
                                1,
                                1,
                                '#XmlDizi[x].Link_Name.XmlText#',
                                '#XmlDizi[x].Object_Folder.XmlText#',
                                '#XmlDizi[x].Object_File_Name.XmlText#',
                                '#Faction_#'
                            )
                    </cfquery>
                    
                    <!--- Xmlde Default Xml ifadeleri varsa Insert ile birlikte xml dosyasi da olusturulur --->
                    <cfset XmlDiziSub = XmlDizi[x].XmlChildren[13].XmlChildren>
                    <cfset XmlCountSub = ArrayLen(XmlDiziSub)>
                    <cfif Len(XmlCountSub) and XmlCountSub gt 0>
                        <cfset SubLoop = XmlCountSub>
                    <cfelse>
                        <cfset SubLoop = 1>
                    </cfif>
                    <cfif Len(SubLoop)>
                        <cfquery name="Get_Max_Row" datasource="#dsn#" maxrows="1">
                            SELECT MAX(ROW_ID) ROW_ID FROM MAIN_SITE_LAYOUTS_SELECTS
                        </cfquery>
                        <cfset my_doc = XmlNew()>
                        <cfset my_doc.xmlRoot = XmlElemNew(my_doc,"OBJECT_PROPERTIES")>
                        <cfloop from="1" to="#SubLoop#" index="y">
                            <cfif Len(XmlCountSub) and XmlCountSub gt 0>
                                <cfset Property_Name_ = XmlDiziSub[y].Property_Name.XmlText>
                                <cfset Property_Detail_ = XmlDiziSub[y].Property_Detail.XmlText>
                                <cfset Property_Value_ = XmlDiziSub[y].Property_Value.XmlText>
                            <cfelse>
                                <cfset Property_Name_ = "">
                                <cfset Property_Detail_ = "">
                                <cfset Property_Value_ = "">
                            </cfif>
                            <cfquery name="Add_Main_Site_Layout_Select_Properties" datasource="#dsn#">
                                INSERT INTO
                                    MAIN_SITE_LAYOUTS_SELECTS_PROPERTIES
                                (
                                    ROW_ID,
                                    PROPERTY_NAME,
                                    PROPERTY_VALUE
                                )
                                VALUES
                                (
                                    #Get_Max_Row.Row_Id#,
                                    '#Property_Name_#',
                                    '#Property_Value_#'								
                                )
                            </cfquery>
                            <cfset my_doc.xmlRoot.XmlChildren[y] = XmlElemNew(my_doc,"OBJECT_PROPERTY")>
                            <cfset my_doc.xmlRoot.XmlChildren[y].XmlChildren[1] = XmlElemNew(my_doc,"PROPERTY")>
                            <cfset my_doc.xmlRoot.XmlChildren[y].XmlChildren[1].XmlText = Property_Name_>
                            <cfset my_doc.xmlRoot.XmlChildren[y].XmlChildren[2] = XmlElemNew(my_doc,"PROPERTY_DETAIL")>
                            <cfset my_doc.xmlRoot.XmlChildren[y].XmlChildren[2].XmlText = Property_Detail_>
                            <cfset my_doc.xmlRoot.XmlChildren[y].XmlChildren[3] = XmlElemNew(my_doc,"PROPERTY_TYPE")>
                            <cfset my_doc.xmlRoot.XmlChildren[y].XmlChildren[3].XmlText = "input">
                            <cfset my_doc.xmlRoot.XmlChildren[y].XmlChildren[4] = XmlElemNew(my_doc,"PROPERTY_VALUES")>
                            <cfset my_doc.xmlRoot.XmlChildren[y].XmlChildren[4].XmlText = Property_Value_>
                            <cfset my_doc.xmlRoot.XmlChildren[y].XmlChildren[5] = XmlElemNew(my_doc,"PROPERTY_NAMES")>
                            <cfset my_doc.xmlRoot.XmlChildren[y].XmlChildren[5].XmlText = "">
                            <cfset my_doc.xmlRoot.XmlChildren[y].XmlChildren[6] = XmlElemNew(my_doc,"PROPERTY_DEFAULT")>
                            <cfset my_doc.xmlRoot.XmlChildren[y].XmlChildren[6].XmlText = "">
                            <cfset my_doc.xmlRoot.XmlChildren[y].XmlChildren[7] = XmlElemNew(my_doc,"PROPERTY_HELP")>
                            <cfset my_doc.xmlRoot.XmlChildren[y].XmlChildren[7].XmlText = "">
                        </cfloop>
                        <cfset dosya = "#Faction_#.xml"> 
                        <cffile action="write" file="#download_folder#workcube_pda#dir_seperator#xml#dir_seperator##dosya#" output="#toString(my_doc)#" charset="utf-8">
                    </cfif>
                </cfloop>
            </cfif>
        </cfif>
    </cftransaction>
</cflock>
<cflocation url="#request.self#?fuseaction=protein.form_upd_main_menu&menu_id=#Get_Max_Menu.menu_id#" addtoken="no">
