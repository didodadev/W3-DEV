<!--- FBS 20101221 Pozisyon Tipi Silinmesi Icin Kontrol Edilen Tablolar, Herhangi Birinde Kayıt Varsa Silinmemeli --->
<cfquery name="Get_Position_Cat_Control" datasource="#dsn#">
	SELECT TOP 1 POSITION_CAT_ID FROM EMPLOYEE_POSITIONS WHERE POSITION_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_cat_id#">
</cfquery>
<cfif not Get_Position_Cat_Control.RecordCount>
	<cfquery name="Get_Position_Cat_Control" datasource="#dsn#">
		SELECT TOP 1 POSITION_CAT_ID FROM EMPLOYEE_POSITIONS_HISTORY WHERE POSITION_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_cat_id#">
	</cfquery>
</cfif>
<cfif not Get_Position_Cat_Control.RecordCount>
	<cfquery name="Get_Position_Cat_Control" datasource="#dsn#">
		SELECT TOP 1 POSITION_CAT_ID FROM EMPLOYEE_POSITIONS_AUTHORITY WHERE POSITION_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_cat_id#">
	</cfquery>
</cfif>
<cfif not Get_Position_Cat_Control.RecordCount>
	<cfquery name="Get_Position_Cat_Control" datasource="#dsn#">
		SELECT TOP 1 POSITION_CAT_ID FROM EMPLOYEE_NORM_POSITIONS WHERE POSITION_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_cat_id#">
	</cfquery>
</cfif>
<cfif not Get_Position_Cat_Control.RecordCount>
	<cfquery name="Get_Position_Cat_Control" datasource="#dsn#"><!--- Olcme Degerlendirme Formu (Eskiden Ana Tabloda Tutulurken, Sonra Asagidaki Related Tablosuna Aktarilip, Coklu Hale Getirilmis) --->
		SELECT TOP 1 POSITION_CAT_ID FROM EMPLOYEE_QUIZ WHERE POSITION_CAT_ID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#attributes.position_cat_id#,%">
	</cfquery>
</cfif>
<cfif not Get_Position_Cat_Control.RecordCount>
	<cfquery name="Get_Position_Cat_Control" datasource="#dsn#"><!--- Olcme Degerlendirme Formu (Iliskili Pozisyon Tipleri Coklu) --->
		SELECT TOP 1 RELATION_ACTION_ID POSITION_CAT_ID FROM RELATION_SEGMENT_QUIZ WHERE RELATION_ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_cat_id#">
	</cfquery>
</cfif>
<cfif not Get_Position_Cat_Control.RecordCount>
	<cfquery name="Get_Position_Cat_Control" datasource="#dsn#"><!--- Secim Listeleri --->
		SELECT TOP 1 POSITION_CAT_ID FROM EMPLOYEES_APP_SEL_LIST WHERE POSITION_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_cat_id#">
	</cfquery>
</cfif>
<cfif not Get_Position_Cat_Control.RecordCount>
	<cfquery name="Get_Position_Cat_Control" datasource="#dsn#">
		SELECT TOP 1 OTHER_POSITION_CODE POSITION_CAT_ID FROM EMPLOYEE_PERFORMANCE_APP WHERE OTHER_POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_cat_id#">
	</cfquery>
</cfif>
<cfif not Get_Position_Cat_Control.RecordCount>
	<cfquery name="Get_Position_Cat_Control" datasource="#dsn#"><!--- Ilanlar --->
		SELECT TOP 1 POSITION_CAT_ID FROM NOTICES WHERE POSITION_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_cat_id#">
	</cfquery>
</cfif>
<cfif not Get_Position_Cat_Control.RecordCount>
	<cfquery name="Get_Position_Cat_Control" datasource="#dsn#"><!--- Menu Ayarlari --->
		SELECT TOP 1 POSITION_CAT_IDS FROM MAIN_MENU_SETTINGS WHERE POSITION_CAT_IDS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#attributes.position_cat_id#,%">
	</cfquery>
</cfif>
<cfif not Get_Position_Cat_Control.RecordCount>
	<cfquery name="Get_Position_Cat_Control" datasource="#dsn#">
		SELECT TOP 1 POSITION_CAT_ID FROM EMPLOYEE_CAREER WHERE POSITION_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_cat_id#"> OR RELATED_POS_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_cat_id#">
	</cfquery>
</cfif>
<cfif not Get_Position_Cat_Control.RecordCount>
	<cfquery name="Get_Position_Cat_Control" datasource="#dsn#"><!--- Yeterlilik --->
		SELECT TOP 1 POSITION_CAT_ID FROM POSITION_REQUIREMENTS WHERE POSITION_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_cat_id#">
	</cfquery>
</cfif>
<cfif not Get_Position_Cat_Control.RecordCount>
	<cfquery name="Get_Position_Cat_Control" datasource="#dsn#"><!--- Ilan Basvurular --->
		SELECT TOP 1 POSITION_CAT_ID FROM EMPLOYEES_APP_POS WHERE POSITION_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_cat_id#">
	</cfquery>
</cfif>
<cfif not Get_Position_Cat_Control.RecordCount>
	<cfquery name="Get_Position_Cat_Control" datasource="#dsn#"><!--- Toplu Maas Ayarlamasi --->
		SELECT TOP 1 POSITION_CAT_ID FROM SALARY_UPDATE_POSITION_CATS WHERE POSITION_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_cat_id#">
	</cfquery>
</cfif>
<cfif not Get_Position_Cat_Control.RecordCount>
	<cfquery name="Get_Position_Cat_Control" datasource="#dsn#"><!--- Organizasyon Simulasyonu --->
		SELECT TOP 1 POSITION_TYPE POSITION_CAT_ID FROM ORGANIZATION_SIMULATION_ROWS WHERE POSITION_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_cat_id#">
	</cfquery>
</cfif>
<cfif not Get_Position_Cat_Control.RecordCount>
	<cfquery name="Get_Position_Cat_Control" datasource="#dsn#"><!--- Icerikler- Kapatilmis Olabilir Kontrol Edilmeli --->
		SELECT TOP 1 POSITION_CAT_ID FROM CONTENT WHERE POSITION_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_cat_id#">
	</cfquery>
</cfif>
<cfif not Get_Position_Cat_Control.RecordCount>
	<cfquery name="Get_Position_Cat_Control" datasource="#dsn#"><!--- Personel Talebi --->
		SELECT TOP 1 POSITION_CAT_ID FROM PERSONEL_REQUIREMENT_FORM WHERE POSITION_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_cat_id#">
	</cfquery>
</cfif>
<cfif not Get_Position_Cat_Control.RecordCount>
	<cfquery name="Get_Position_Cat_Control" datasource="#dsn#"><!--- Atama Talebi --->
		SELECT TOP 1 POSITION_CAT_ID FROM PERSONEL_ASSIGN_FORM WHERE POSITION_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_cat_id#">
	</cfquery>
</cfif>
<cfif Get_Position_Cat_Control.RecordCount>
	<cfset IsDelete_ = 0>
</cfif>
