<cfif isdefined('attributes.start_date') and isdate(attributes.start_date)>
	<cf_date tarih = "attributes.start_date" >
</cfif>
<cfif isdefined('attributes.finish_date') and isdate(attributes.finish_date)>
	<cf_date tarih = "attributes.finish_date" >
</cfif>
<cfinclude template="../query/get_group_classes.cfm">
<cfset cls_liste=valuelist(get_tr_name.CLASS_ID)><!--- eğitimleri alıyor --->
<cfset chapter_currentrow = 0> 
<cfquery name="get_trainings" datasource="#dsn#">
	SELECT
		TC.CLASS_ID,
		TC.CLASS_NAME,
		TC.START_DATE,
		TC.FINISH_DATE, 
		TCG.CLASS_GROUP_ID 
	FROM
		TRAINING_CLASS_GROUP_CLASSES TCG,
		TRAINING_CLASS TC
	WHERE
		TC.CLASS_ID=TCG.CLASS_ID
		<cfif len(cls_liste)>
	        AND TC.CLASS_ID IN(#cls_liste#)
        </cfif>
	AND
		TCG.TRAIN_GROUP_ID=#attributes.train_group_id#
	ORDER BY TC.CLASS_ID
</cfquery>
<cfset s_date_list = ''>
<cfset f_date_list = ''>
<cfloop query="get_trainings">
	<cfset s_date_list = ListAppend(s_date_list,START_DATE,',')>
	<cfset f_date_list = ListAppend(f_date_list,FINISH_DATE,',')>
</cfloop>
<cfset liste="">
<cfloop from="1" to="#attributes.max#" index="i">
	<cfif isdefined("attributes.secenek#i#")>
		<cfset deger=evaluate("attributes.secenek#i#")>
		<cfif LEN(deger)>
			<cfset deger="#deger#-#i#">		
		<cfelse>
			<cfset deger="A-#i#">
		</cfif>
		<cfset liste=ListAppend(liste,deger,",")>
	</cfif>
</cfloop>
<cfset kapak_list = "">
<cfloop from="1" to="#attributes.max#" index="i">
   <cfif isdefined("attributes.header#i#")>
     <cfset kapak_deg =evaluate("attributes.header#i#")>
	 <cfif len(kapak_deg)>
	    <cfset kapak_deg = "#kapak_deg#-#i#">
	 <cfelse>
	     <cfset kapak_deg="K-#i#">
	 </cfif>
	 <cfset kapak_list = listappend(kapak_list,kapak_deg,",")>
   </cfif>
</cfloop>

<cfset arr_temp="">
<cfloop from="1" to="#listlen(liste)#" index="i" >
	<cfloop from="1" to="#evaluate(listlen(liste)-i)#" index="j">
		<cfset temp1_val=listgetat(liste,i)>
		<cfset temp1=listgetat(listgetat(liste,i),1,"-")>
		<cfset temp2=listgetat(listgetat(liste,j),1,"-")>
		<cfif temp1 gt temp2>
			<cfscript>
				ListSetAt(liste, i, listgetat(liste,j),",");
				ListSetAt(liste, j, temp1_val,",");
			</cfscript>
		</cfif>
	</cfloop>
</cfloop>
<table style="height:290mm;width:197mm;" border="0">
	<cfloop from="1" to="#listlen(liste)#" index="i">
		<cfset ch_sub_list=listgetat(liste,i)>
		<cfset s=ListGetAt(ch_sub_list,2,"-")>
		
	   <cfif i lte listlen(kapak_list)>
		<cfset kapak = listgetat(kapak_list,i)>
	   </cfif>	
		
		<cfif isDefined("attributes.KONSOLIDE")>
		  <cfloop list="#attributes.KONSOLIDE#" index="k">
		    <cfif k eq s>
			   <cfset attributes.kons_sayi = k>
			</cfif>
		  </cfloop>
		</cfif>
		
		<cfif not isdefined("attributes.kons_sayi")>
		<!--- ************BURADA KONSOLIDE KONTROLUNU YAP *********** --->
		<cfif ListGetAt(ch_sub_list,1,"-") neq "A" and ( s lte 5 or (s gte 9 and s lte 15) )>
			<!--- tüm egitimler icin bir loop olucak  --->
			<cfif isdefined("kapak") and listgetat(kapak,1,"-") neq "K" and (s lte 5 or (s eq 9 or s eq 12 or s eq 14 or s eq 15 )) >
			  <cfset attributes.kapak_bas = listgetat(kapak,1,"-")>
			</cfif>
			<cfif LEN(cls_liste)>
				<cfloop from="1" to="#ListLen(cls_liste)#" index="j">
					<cfset attributes.class_id=ListGetAt(cls_liste,j)>
					<cfinclude template="../query/get_report_queries.cfm">
					<cfinclude template="../query/get_upd_class_queries.cfm">
					<tr>
						<td>
							<cfif isdefined("attributes.excused")>
                              <cfset attributes.excused1 = attributes.excused>
                            </cfif> 
                            
                            <cfset name_of_file="training_report_#ListGetAt(ch_sub_list,2,"-")#.cfm">
                            <cfinclude template="#name_of_file#"> 
						</td>
					</tr>	
				</cfloop>
			</cfif>
		<cfelseif ListGetAt(ch_sub_list,1,"-") neq "A" >
		   
		    
			<!--- tüm egitimler icin bir loop olucak  --->
			<cfif LEN(cls_liste)>			
				<cfloop from="1" to="#ListLen(cls_liste)#" index="j">
					<cfset attributes.class_id=ListGetAt(cls_liste,j)>
					<cfinclude template="../query/get_report_queries.cfm">	
					<cfinclude template="../query/get_upd_class_queries.cfm">							
					<tr>
						<td>
						 <cfif isdefined("attributes.graph_dimension#ListGetAt(ch_sub_list,2,"-")#") and len(evaluate("attributes.graph_dimension#ListGetAt(ch_sub_list,2,"-")#"))>
						    <cfset attributes.graph_dim = evaluate("attributes.graph_dimension#ListGetAt(ch_sub_list,2,"-")#")>
						 </cfif>	
						 <cfif isdefined("attributes.graph_type#ListGetAt(ch_sub_list,2,"-")#") and len(evaluate("attributes.graph_type#ListGetAt(ch_sub_list,2,"-")#"))>
						   <cfset attributes.gr_type = evaluate("attributes.graph_type#ListGetAt(ch_sub_list,2,"-")#")>
						 </cfif> 
						 <cfif isdefined("attributes.list#ListGetAt(ch_sub_list,2,"-")#") and len(evaluate("attributes.list#ListGetAt(ch_sub_list,2,"-")#"))>
						   <cfset attributes.list = 1>
						 </cfif>
						<cfif  isdefined("attributes.gizli#s#") and LEN(evaluate("attributes.gizli#s#"))>
							<cfset attributes.quiz_id = evaluate("attributes.gizli#s#")>
							<cfinclude template="training_report_6.cfm"> 
						</cfif>
						</td>
					</tr>	
				</cfloop>
			</cfif>				
		</cfif>
		<!--- ** --->
		<cfelse>
		   <cfif ListGetAt(ch_sub_list,1,"-") neq "A" and ( s lte 5 or (s gte 9 and s lte 15) )>
			<!--- tüm egitimler icin bir loop olucak  ---><!--- statik raporlar --->
			<cfif LEN(cls_liste)>
			   <cfset attributes.class_id_list = cls_liste>
			   <cfif isdefined("attributes.excused")>
                   <cfset attributes.excused1 = attributes.excused>
               </cfif> 
			   
			   
			   <cfif isdefined("kapak") and listgetat(kapak,1,"-") neq "K" and (s lte 5 or (s eq 9 or s eq 12 or s eq 14 or s eq 15 )) >
			    <cfset attributes.kapak_bas = listgetat(kapak,1,"-")>
			   </cfif>
			   
			   <cfset name_of_file="training_report_#ListGetAt(ch_sub_list,2,"-")#_2.cfm">
			   <cfinclude template="#name_of_file#"> 
			 
			</cfif>
		  <cfelseif ListGetAt(ch_sub_list,1,"-") neq "A" >  <!--- dinamik raporlar --->
			<!--- tüm egitimler icin bir loop olucak  --->
			<cfif LEN(cls_liste)>			
			  <cfset attributes.class_id_list = cls_liste>
			   <cfif isdefined("attributes.excused")>
                   <cfset attributes.excused1 = attributes.excused>
               </cfif> 
			   <cfif isdefined("attributes.graph_dimension#ListGetAt(ch_sub_list,2,"-")#") and len(evaluate("attributes.graph_dimension#ListGetAt(ch_sub_list,2,"-")#"))>
				  <cfset attributes.graph_dim = evaluate("attributes.graph_dimension#ListGetAt(ch_sub_list,2,"-")#")>
			   </cfif>	
			   <cfif isdefined("attributes.graph_type#ListGetAt(ch_sub_list,2,"-")#") and len(evaluate("attributes.graph_type#ListGetAt(ch_sub_list,2,"-")#"))>
				  <cfset attributes.gr_type = evaluate("attributes.graph_type#ListGetAt(ch_sub_list,2,"-")#")>
			   </cfif> 
			   <cfif isdefined("attributes.list#ListGetAt(ch_sub_list,2,"-")#") and len(evaluate("attributes.list#ListGetAt(ch_sub_list,2,"-")#"))>
				   <cfset attributes.list = 1>
			   </cfif>
			   
			   <cfif  isdefined("attributes.gizli#s#") and LEN(evaluate("attributes.gizli#s#"))>
				  <cfset attributes.quiz_id = evaluate("attributes.gizli#s#")>
				  <cfinclude template="training_report_6_3.cfm"> 
			   </cfif>
				
			</cfif>				
		</cfif>
		     
		</cfif>
		<!---**--->
	</cfloop>
</table>
<cfscript>
	StructDelete(session,"training_management");
</cfscript>
