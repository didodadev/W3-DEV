<cfset attributes.d_training_sec_id = get_class.training_sec_id>
<cfscript>
	get_training_sec_action = createObject("component","V16.training.cfc.get_training_sec_names");
	get_training_sec_action.dsn = dsn;
	get_training_sec_names = get_training_sec_action.get_training_sec_fnc
					(
						module_name : fusebox.circuit,
						training_sec_id : attributes.d_training_sec_id
					);
</cfscript>
<cfquery name="GET_RELATED_CLASSES" datasource="#DSN#">
	SELECT 
        CR.ACTION_TYPE_ID, 
        CR.CLASS_ID,
        (SELECT TC.CLASS_NAME FROM TRAINING_CLASS TC WHERE TC.CLASS_ID = CR.CLASS_ID) CLASS_NAME 
    FROM 
        CLASS_RELATION CR 
    WHERE 
        CR.ACTION_TYPE = 'CLASS_ID' AND 
        ACTION_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.class_id#">
</cfquery>

<table>
    <cfif get_training_sec_names.recordcount>
      <tr>
          <td><cf_get_lang_main no ='74.Kategori'>/<cf_get_lang_main no='583.Bölüm'>:</td>
          <td><cfoutput>#get_training_sec_names.training_cat# / #get_training_sec_names.section_name#</cfoutput></td>  
      </tr>
    </cfif>
  <tr>
      <td><cf_get_lang_main no='68.Başlık'>:</td>
      <td>
          <cfoutput>#get_class.class_name#:</cfoutput>
          <cfif get_class.online eq 1> / <cf_get_lang_main no='2218.Online'><cfelse><cf_get_lang no='22.Yüzyüze'></cfif>
      </td>
  </tr>
  <cfif get_class.online eq 1>
    <tr>
        <td><cf_get_lang dictionary_id='39619.Link'>:</td>
        <td><a href="<cfoutput>#get_class.training_link#</cfoutput>" target="_blank"><cfoutput>#get_class.training_link#</cfoutput></a></td>
    </tr>
  </cfif>
  <tr>
      <td><cf_get_lang no='7.Amaç'>:</td>
      <td><cfoutput>#get_class.class_target#</cfoutput></td>
  </tr>
  <tr>
      <td><cf_get_lang_main no='330.Tarih'>:</td>
      <td>
          <cfif len(get_class.start_date)><cfoutput>#dateformat(start_date_,dateformat_style)# #timeformat(start_date_,timeformat_style)#</cfoutput> - </cfif>
          <cfif len(get_class.finish_date)><cfoutput>#dateformat(finish_date_,dateformat_style)# #timeformat(finish_date_,timeformat_style)#</cfoutput></cfif>
      </td>
  </tr>
  <tr>
      <td>Eğitimciler:</td>
      <td>
          <cfscript>
              get_trainers = createObject("component","V16.training_management.cfc.get_class_trainers");
              get_trainers.dsn = dsn;
              get_trainer_names = get_trainers.get_class_trainers
                              (
                                  module_name : fusebox.circuit,
                                  class_id : get_class.class_id
                              );
          </cfscript>
          <cfoutput query="get_trainer_names">
              #trainer#,
          </cfoutput>
      </td> 
  </tr>
  <tr>
      <td><cf_get_lang no='199.İlişkili Eğitim'>:</td>
      <td>
          <cfif get_related_classes.recordcount>
              <cfoutput query="get_related_classes">
                  <cfscript>
                      get_related_class_action = createObject("component","V16.training.cfc.get_class");
                      get_related_class_action.dsn = dsn;
                      get_related_class = get_related_class_action.get_class_fnc
                                      (
                                          module_name : fusebox.circuit,
                                          class_id : get_related_classes.class_id
                                      );
                  </cfscript>
                  #get_related_classes.class_name# <br/>
              </cfoutput>
          </cfif>
      </td> 
  </tr>
</table>
