<cfcomponent>
<cfscript>
	function IMsgIcon(IMCAT_ICON, IM, IMCAT_LINK_TYPE, IMCAT_ID)
	{
		// INSTANT MESSAGE ICON ve LINK ENTEGRASYONU | MG 20101130

		stil = "style=""cursor: hand;""";
		if (Len(IMCAT_ICON))
		{
			ImAddress = IM;
			LinkType = IMCAT_LINK_TYPE;
		}
		else
		{
			ImAddress = "Bu Instant Mesaj kaydının kategorisi bulunamadı, lütfen IM Bilgilerinizi güncelleyiniz.";
			IMCAT_ICON = "icons_invalid.gif";
			LinkType = "";
		}
		Link = LinkType & ImAddress;
		if (LinkType == "")
			Link = "##"; stil = "";
		if (Len(IMCAT_ID))
			WriteOutput("<img onclick=""javascript:location.href='" & Link & "';"" src=""/documents/settings/#IMCAT_ICON#"" border=""0"" " & stil & " alt=""" & ImAddress & """>");
	}

	function txtToImage(txtStr, txtSize, imgWidth, imgHeight, txtStyle, txtFont, txtColor, imgBackColor, imgRotateDegree)
	{
		// Parametre olarak verilen bir metni Resim formatında geri döndürür. MG 23.06.2011

		// txtStr:			Metin (string),
		// txtSize:			font-size (int),
		// imgWidth:		Resmin genişlik değeri (int),
		// imgHeight:		Resmin yükseklik değeri (int),
		// txtStyle:		Metnin style değeri (bold, italic, boldItalic) (string),
		// txtFont:			Metnin font-family değeri (string),
		// txtColor:		Metnin rengi (string),
		// imgBackColor:	Resmin arkaplan rengi (string),
		// imgRotateDegree:	Resmin dönme derecesi (int)

		fontProperties = StructNew();
		fontProperties.style = txtStyle;
		fontProperties.size = txtSize;
		fontProperties.font = txtFont;

		newImage = ImageNew("", imgHeight, imgWidth, "argb", imgBackColor);
		ImageSetDrawingColor(newImage, txtColor);
		ImageDrawText(newImage, txtStr, 0, 15, fontProperties);
		ImageRotate(newImage, imgRotateDegree);

		return newImage;

		// Örnek Kullanım:
		// <cfimage action="writeTobrowser" source="#txtToImage(Evaluate("b" & sayy), 11, 22, 150, "bold", "Verdana", "Black", true, 270)#">
	}

	function AgiHesapla(agiSalary, yearlyPercent, mateWorkingState, child_1_Age, child_2_Age, child_3_Age, child_4_Age, child_1_Edu, child_2_Edu, child_3_Edu, child_4_Edu)
	{
		// Parametre olarak bilgilerini gönderilen bir çalışanın AGİ tutarını döndürür.

		// prm1:	empAge:					Çalışanın yaşı
		// prm2:	yearlyPercent:			AGİ Hesabında kullanılacak yüzdesi (Ör: 2011 --> 0.15)
		// prm3:	mateWorkingState:		Eşinin çalışma durumu ( Bekarsa; 0, Evli ve eşi çalışıyorsa; 1, Evli ve eşi çalışmıyorsa; 2 )
		// prm4:	child_1_Age:			Varsa) 1. Çocuğunun yaşı ( Çocuğu yoksa; 0, varsa yaşı )
		// prm5:	child_2_Age:			Varsa) 2. Çocuğunun yaşı ( Çocuğu yoksa; boş bırakılabilir veya 0 yazılır, varsa yaşı )
		// prm6:	child_3_Age:			Varsa) 3. Çocuğunun yaşı ( Çocuğu yoksa; boş bırakılabilir veya 0 yazılır, varsa yaşı )
		// prm7:	child_4_Age:			Varsa) 4. Çocuğunun yaşı ( Çocuğu yoksa; boş bırakılabilir veya 0 yazılır, varsa yaşı )
		// prm8:	child_1_Edu:			Varsa) 1. Çocuğunun okul durumu ( Çocuğu yoksa; boş bırakılabilir veya 0 yazılır, okula gidiyorsa 1 yazılır )
		// prm9:	child_2_Edu:			Varsa) 2. Çocuğunun okul durumu ( Çocuğu yoksa; boş bırakılabilir veya 0 yazılır, okula gidiyorsa 1 yazılır )
		// prm10:	child_3_Edu:			Varsa) 3. Çocuğunun okul durumu ( Çocuğu yoksa; boş bırakılabilir veya 0 yazılır, okula gidiyorsa 1 yazılır )
		// prm11:	child_4_Edu:			Varsa) 4. Çocuğunun okul durumu ( Çocuğu yoksa; boş bırakılabilir veya 0 yazılır, okula gidiyorsa 1 yazılır )

		defaultAgiPercent = 50;

		if (mateWorkingState eq 1)
			agiTotalPercent = defaultAgiPercent + 10;

		if (child_1_Edu eq 1)
		{
			if (child_1_Age <= 25)
				agiTotalPercent = agiTotalPercent + 7.5;
		}
		else
		{
			if (child_1_Age <= 18)
				agiTotalPercent = agiTotalPercent + 7.5;
		}

		if (child_2_Edu eq 1)
		{
			if (child_2_Age <= 25)
				agiTotalPercent = agiTotalPercent + 7.5;
		}
		else
		{
			if (child_2_Age <= 18)
				agiTotalPercent = agiTotalPercent + 7.5;
		}

		if (child_3_Edu eq 1)
		{
			if (child_3_Age <= 25)
				agiTotalPercent = agiTotalPercent + 5;
		}
		else
		{
			if (child_3_Age <= 18)
				agiTotalPercent = agiTotalPercent + 5;
		}

		if (child_4_Edu eq 1)
		{
			if (child_4_Age <= 25)
				agiTotalPercent = agiTotalPercent + 5;
		}
		else
		{
			if (child_4_Age <= 18)
				agiTotalPercent = agiTotalPercent + 5;
		}

		return agiSalary * yearlyPercent * agiTotalPercent;
	}
</cfscript>

<cffunction name="wrk_content_sub_clear" output="false" returntype="string">
	<cfargument name="cont" required="true" default="">
	<cfargument name="ilk_eleman" required="true" default="">
	<cfargument name="son_eleman" required="true" default="">
	<cfscript>
		start = findnocase(arguments.ilk_eleman,cont,1);
		middle = findnocase(arguments.son_eleman,cont,start + len(arguments.ilk_eleman));
		while((start GT 0) and (middle GT 0))
			{
			cont = removechars(cont,start,middle-start+len(arguments.son_eleman));
			start = findnocase(arguments.ilk_eleman,cont,1);
			middle = findnocase(arguments.son_eleman,cont,start + len(arguments.ilk_eleman));
			}
	</cfscript>
	<cfreturn cont>
</cffunction>

<cffunction name="getFamily" access="remote" returntype="string" returnFormat="plain">
	<cfargument name="dsn" required="yes">
    <cfargument name="solutionId" required="yes">
    <cfquery name="getFamilies" datasource="#arguments.dsn#">
        SELECT
            WRK_FAMILY_ID,
            ISNULL(SL.ITEM_#session.ep.language#,FAMILY) AS NAME
        FROM
            WRK_FAMILY WF
            LEFT JOIN SETUP_LANGUAGE_TR SL ON WF.FAMILY_DICTIONARY_ID = SL.DICTIONARY_ID
        WHERE
            WRK_SOLUTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.solutionId#">
		ORDER BY
			ISNULL(SL.ITEM_#session.ep.language#,FAMILY)
    </cfquery>
    <cfreturn Replace(serializeJSON(getFamilies),'//','')>
</cffunction>

<cffunction name="getModule" access="remote" returntype="string" returnFormat="plain">
	<cfargument name="dsn" required="yes">
    <cfargument name="familyId" required="yes">
    <cfquery name="getModules" datasource="#arguments.dsn#">
        SELECT
            M.MODULE_NO,
            ISNULL(SL.ITEM_#session.ep.language#,MODULE) AS NAME
        FROM
            WRK_MODULE AS M
            LEFT JOIN SETUP_LANGUAGE_TR SL ON M.MODULE_DICTIONARY_ID = SL.DICTIONARY_ID
        WHERE
            M.FAMILY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.familyId#">
		ORDER BY
			ISNULL(SL.ITEM_#session.ep.language#,MODULE)
    </cfquery>
    <cfreturn Replace(serializeJSON(getModules),'//','')>
</cffunction>
<cffunction name="getWatomicFamily" access="remote" returntype="string" returnFormat="plain">
	<cfargument name="dsn" required="yes">
    <cfargument name="solutionId" required="yes">
    <cfquery name="getWatomicFamily" datasource="#arguments.dsn#">
        SELECT
			WRK_WATOMIC_FAMILY_ID,
            ISNULL(SL.ITEM_#session.ep.language#,WATOMIC_FAMILY_NAME) AS NAME
        FROM
			WRK_WATOMIC_FAMILY WWF
            LEFT JOIN SETUP_LANGUAGE_TR SL ON WWF.WRK_WATOMIC_FAMILY_DICTONARY_ID = SL.DICTIONARY_ID
        WHERE
			WRK_WATOMIC_SOLUTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.solutionId#">
		ORDER BY
			ISNULL(SL.ITEM_#session.ep.language#,WATOMIC_FAMILY_NAME)
    </cfquery>
    <cfreturn Replace(serializeJSON(getWatomicFamily),'//','')>
</cffunction>

<cffunction name="find_gt_element" output="false" returntype="string">
	<cfargument name="cont" required="true" default="">
	<cfargument name="ilk_eleman" required="true" default="">
	<cfscript>
		start = findnocase(arguments.ilk_eleman,cont,1);
		if(start gt 0)
		{
			kalan_ = left(cont,start);
			aranacak_cumle = mid(cont,findnocase(listlast(kalan_,'<'),kalan_,1)-1,start-findnocase(listlast(kalan_,'<'),kalan_,1)+len(arguments.ilk_eleman)+1);
			if(len(aranacak_cumle))
				cont = wrk_content_sub_clear(cont,aranacak_cumle,'</table>');
			else
				cont = cont;
		}
		else
			cont = cont;
	</cfscript>
	<cfreturn cont>
</cffunction>
<cffunction name="wrk_content_clear" output="false" returntype="string">
	<cfargument name="cont" required="true" type="string" default="">
		<cfscript>
			cont = ReplaceList(cont,'  ','');
			cont = ReplaceList(cont,chr(10),' ');
			cont = ReplaceList(cont,chr(13),' ');
			cont = ReplaceList(cont,chr(39),'');
			cont = Replace(cont,'title=','alt=','all');
		</cfscript>
			<cfset cont = "<!-- sil -->" & trim(arguments.cont) & "<!-- sil -->">
			<cfset cont = wrk_content_sub_clear (cont,'<!-- sil -->','<!-- sil -->')>
			<cfset cont = wrk_content_sub_clear (cont,'<!-- siil -->','<!-- siil -->')>
			<cfset cont = wrk_content_sub_clear (cont,'<script','</script>')>
			<cfset cont = wrk_content_sub_clear (cont,'<InvalidTag','</script>')> <!--- Yukaridaki script ifadesi birsekilde invalidTag olarak degisiyor. Kontrol amacli eklendi. EY20130827 --->
			<cfset cont = wrk_content_sub_clear (cont,'<map','</map>')><!--- Cfchart ile olusuturulan grafiklerde geliyor. Bu etiketin oldugu imaj bulunup silinecek. EY20131001 --->
            <cfset cont = wrk_content_sub_clear (cont,'<!-- del -->','<!-- del -->')><!--- Big_list custom tag'inde gizlenen alanlar için düzenleme yapıldı. Böylelikle ekrandan gizlenen alanların excel,pdf'e gelmemesi sağlandı. --->

            <cfloop condition = "findnocase('CFIDE',cont) gt 0">
				<cfset cont = find_gt_element (cont,'CFIDE')><!--- CFIDE etiketi cfchart ile olusuturulan grafiklerde geliyor. Bu etiketin oldugu imaj bulunup silinecek. EY20131001 --->
            </cfloop>
			<cfset cont = find_gt_element (cont,'widows: 0')><!--- Rapor modulunde kullanilan thead fixleme fonksiyonu excel alirken js tarafinda 2 tane daha ayni table'i olusturuyordu diye bu fazlaliklari atiyoruz. Widows parametresini js icinde biz ekliyoruz. Diger sayfalari bozmaz EY20131001 --->
			<cfset cont = find_gt_element (cont,'WIDOWS: 0')><!--- Rapor modulunde kullanilan thead fixleme fonksiyonu excel alirken js tarafinda 2 tane daha ayni table'i olusturuyordu diye bu fazlaliklari atiyoruz. Widows parametresini js icinde biz ekliyoruz. Diger sayfalari bozmaz EY20131001 --->
			<cfif browserDetect() contains 'Chrome'>
                <cfset cont = find_gt_element (cont,'table-layout:fixed;')>
                <cfset cont = find_gt_element (cont,'style="margin: 0px;"')>
                <cfset cont = ReReplaceNoCase(cont,"<link[^>]*>", "", "ALL")>
			</cfif>
			<cfset cont = find_gt_element (cont,'class="big_list_search"')>
       <!---<cfset cont = wrk_content_sub_clear (cont,'<UL>','</UL>')> Bu kısım içerik PDF'i basılmasında gerekli <ul> tagının kullanılmasında sorun yarattığı için kaldırılmıştır.
			<cfset cont = wrk_content_sub_clear (cont,'<ul>','</ul>')>--->
			<cfset cont = ReReplaceNoCase(cont,"<html[^>]*>", "", "ALL")>
			<cfset cont = ReReplaceNoCase(cont,"<div[^>]*>", "", "ALL")>
			<cfset cont = ReReplaceNoCase(cont,"</div>", "", "ALL")>
			<cfset cont = ReReplaceNoCase(cont,"<section[^>]*>", "", "ALL")>
			<cfset cont = ReReplaceNoCase(cont,"</section>", "", "ALL")>
			<cfset cont = ReReplaceNoCase(cont,"<meta[^>]*>", "", "ALL")>
			<cfset cont = ReReplaceNoCase(cont,"<head[^>]*>", "", "ALL")>
			<cfset cont = ReReplaceNoCase(cont,"</head[^>]*>", "", "ALL")>
			<cfset cont = ReReplaceNoCase(cont,"</html[^>]*>", "", "ALL")>
			<cfset cont = ReReplaceNoCase(cont,"<form[^>]*>", "", "ALL")>
			<cfset cont = ReReplaceNoCase(cont,"</form>", "", "ALL")>
			<cfset cont = ReReplaceNoCase(cont,"<a[^>]*>", "", "ALL")>
			<cfset cont = ReReplaceNoCase(cont,"</a>", "", "ALL")>
			<cfset cont = ReReplaceNoCase(cont,'<input type="text[^>]*>', '', 'ALL')>
			<cfset cont = ReReplaceNoCase(cont,'<input[^>]*>', '', 'ALL')>
			<!---<cfset cont = ReReplaceNoCase(cont,'<img[^>]*>', '', 'ALL')>--->
			<cfset cont = ReReplaceNoCase(cont,"<select[^>]*>", "", "ALL")>
			<cfset cont = ReReplaceNoCase(cont,"</select[^>]*>", "", "ALL")>
			<cfset cont = ReReplaceNoCase(cont,"<option[^>]*>", "", "ALL")>
			<cfset cont = ReReplaceNoCase(cont,"</option[^>]*>", "", "ALL")>
			<cfset cont = ReReplaceNoCase(cont,"<textarea[^>]*>", "", "ALL")>
			<cfset cont = ReReplaceNoCase(cont,"</textarea>", "", "ALL")>
			<cfset cont = ReReplaceNoCase(cont,'onmouseover=[^>]*"', ' ', 'ALL')>
			<cfset cont = ReReplaceNoCase(cont,'onmouseout=[^>]*"', ' ', 'ALL')>
            <cfset cont = ReReplaceNoCase(cont,'&nbsp;', ' ', 'ALL')>
			<cfset cont = ReReplaceNoCase(cont,"<a[^>]*>", "", "ALL")>
			<cfset cont = ReReplaceNoCase(cont,"</a>", "", "ALL")>
			<cfset cont = ReReplaceNoCase(cont,"<font[^>]*>", "", "ALL")>
			<cfset cont = ReReplaceNoCase(cont,"</font>", "", "ALL")>
			<cfset cont = ReReplaceNoCase(cont,' class=[^>]*"', '', 'ALL')>
			<cfset cont = ReReplaceNoCase(cont,' role=[^>]*"', '', 'ALL')>
			<cfset cont = ReReplaceNoCase(cont,' style=[^>]*"', '', 'ALL')>
            <cfset cont = trim(cont)>
	<cfreturn cont>
</cffunction>

<cffunction name="structToListFunc" returntype="string" output="false">
	<cfargument name="s" required="no"><!---  type="numeric" --->
    <cfargument name="x" required="no"><!---  type="numeric" --->
	<cfscript>
		var delim = "&";
		var i = 0;
		var newArray = structKeyArray(arguments.s);
	
		if (arrayLen(arguments) gt 1) delim = arguments[x];
	
		for(i=1;i lte structCount(arguments.s);i=i+1) newArray[i] = newArray[i] & "=" & arguments.s[newArray[i]];
	
		return arraytoList(newArray,delim);
	</cfscript>
</cffunction>

<cffunction name="wrk_form_sms_template" returntype="string" output="true">
<!---
	by : TolgaS 20080906
	notes : bu form şekli kampanya ve ayarlarda olduğundan birine eklendiğinde öteki unutulmaması için 
	usage :
		wrk_form_sms_template(sms_body: '',is_camp:1);
	--->
	<cfargument name="sms_body" type="string" default="">
	<cfargument name="is_table" type="numeric" default="1">
    <cfargument name="is_camp" type="numeric" default="0"><!--- kampanyadan geliyor ise gösterilmek istenmeyen değişkenler ayarlanır --->
    <cfif arguments.is_table eq 1>
		<td valign="top"><cf_get_lang dictionary_id='58610.SMS İçeriği'>*</td>
		<td><textarea name="sms_body" id="sms_body" style="width:250px;height:75px;" cols="40" rows="6" maxlength="500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);"><cfoutput>#arguments.sms_body#</cfoutput></textarea></td>
		<td><input type="button" name="add_var" id="add_var" value="<< " onclick="document.getElementById('sms_body').value=document.getElementById('sms_body').value+document.getElementById('add_variable').options[document.getElementById('add_variable').selectedIndex].value"> </td>
		<td>
			<select name="add_variable" id="add_variable" style="width:200px;height:75px;" multiple="multiple">
				<option value="[VAR_COMPANY_NAME]"><cf_get_lang dictionary_id='58611.Üyenin Şirket Kısa Adı'></option>
				<option value="[VAR_MEMBER_NAME]"><cf_get_lang dictionary_id='58612.Üye Şirket Çalışanı'></option>
				<option value="[VAR_CHEQUE_REMAINDER]"><cf_get_lang dictionary_id='58613.Üye Çek Bakiyesi'></option>
				<option value="[VAR_VOUCHER_REMAINDER]"><cf_get_lang dictionary_id='58614.Üye Senet Bakiyesi'></option>
				<option value="[VAR_MEMBER_REMAINDER]"><cf_get_lang dictionary_id='58615.Üye Bakiyesi'></option>
				<cfif arguments.is_camp neq 1><option value="[VAR_PAPER_NUMBER]"><cf_get_lang dictionary_id='58616.Belge Numarası'></option></cfif>
				<option value="[VAR_MY_COMPANY_NAME]"><cf_get_lang dictionary_id='58617.Bulunduğunuz Şirket Adı'></option>
				<option value="[VAR_MY_NAME]"><cf_get_lang dictionary_id='58618.SMS Yollayan Kişinin Adı Soyadı'></option>
			</select>
		</td>
	<cfelse>
		<label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='58610.SMS İçeriği'>*</label>
		<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
			<div class="col col-5 col-md-5 col-sm-5 col-xs-4">
				<select name="add_variable" id="add_variable" multiple="multiple" style="width:250px;height:75px;">
					<option value="[VAR_COMPANY_NAME]"><cf_get_lang dictionary_id='58611.Üyenin Şirket Kısa Adı'></option>
					<option value="[VAR_MEMBER_NAME]"><cf_get_lang dictionary_id='58612.Üye Şirket Çalışanı'></option>
					<option value="[VAR_CHEQUE_REMAINDER]"><cf_get_lang dictionary_id='58613.Üye Çek Bakiyesi'></option>
					<option value="[VAR_VOUCHER_REMAINDER]"><cf_get_lang dictionary_id='58614.Üye Senet Bakiyesi'></option>
					<option value="[VAR_MEMBER_REMAINDER]"><cf_get_lang dictionary_id='58615.Üye Bakiyesi'></option>
					<cfif arguments.is_camp neq 1><option value="[VAR_PAPER_NUMBER]"><cf_get_lang dictionary_id='58616.Belge Numarası'></option></cfif>
					<option value="[VAR_MY_COMPANY_NAME]"><cf_get_lang dictionary_id='58617.Bulunduğunuz Şirket Adı'></option>
					<option value="[VAR_MY_NAME]"><cf_get_lang dictionary_id='58618.SMS Yollayan Kişinin Adı Soyadı'></option>
				</select>
			</div>
			
			<div class="col col-1 col-md-1 col-sm-1 col-xs-4">
				<a class="ui-ripple-btn margin-top-20" onclick="document.getElementById('sms_body').value=document.getElementById('sms_body').value+document.getElementById('add_variable').options[document.getElementById('add_variable').selectedIndex].value"><i class="fa fa-chevron-right"></i></a>						
			</div>
			<div class="col col-6 col-md-6 col-sm-6 col-xs-4">
				<textarea name="sms_body" id="sms_body" style="width:250px;height:75px;" cols="40" rows="6" maxlength="500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);"><cfoutput>#arguments.sms_body#</cfoutput></textarea>
			</div>
		</div>
	</cfif>
</cffunction>

<cffunction name="wrk_sms_body_replace" returntype="string" output="false">
<!---
	by : TolgaS 20080906
	notes : sms şablonundaki değişkenleri temizler yerlerine olması gereken değerleri atar
	usage : wrk_sms_body_replace(sms_body:'',member_type:'company',member_id:321,paper_type:1,paper_id:3214);
	--->
	<cfargument name="sms_body" type="string" required="yes">
	<cfargument name="member_type" type="string" default="">
	<cfargument name="member_id" type="string" default="">
	<cfargument name="paper_type" type="string" default="">
	<cfargument name="paper_id" type="string" default="">
	<cfargument name="dsn_type" type="string" default="">
	<cfargument name="is_process" type="numeric" default="0">
	<cfif arguments.is_process>
		<cfscript>
			dsn=caller.dsn;
			dsn_alias=caller.dsn_alias;
			dsn1=caller.dsn1;
			dsn1_alias=caller.dsn1_alias;
			dsn2=caller.dsn2;
			dsn2_alias=caller.dsn2_alias;
			dsn3=caller.dsn3;
			dsn3_alias=caller.dsn3_alias;
		</cfscript>
	</cfif>
	<cfif not len(arguments.dsn_type)><cfset arguments.dsn_type=dsn></cfif>

    <!--- üye bilgileri alınıyor --->
	<cfif arguments.member_type eq 'company'>
        <cfquery name="GET_MEMBER_SMS" datasource="#arguments.dsn_type#">
         SELECT 
             COMPANY_PARTNER.PARTNER_ID,
             COMPANY_PARTNER.COMPANY_PARTNER_NAME+' '+COMPANY_PARTNER.COMPANY_PARTNER_SURNAME AS MEMBER_NAME,
             COMPANY.COMPANY_ID,
             COMPANY.NICKNAME
           FROM 
             #dsn_alias#.COMPANY_PARTNER COMPANY_PARTNER,	
             #dsn_alias#.COMPANY COMPANY
        WHERE 
           COMPANY.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.member_id#"> AND
           COMPANY_PARTNER.PARTNER_ID= COMPANY.MANAGER_PARTNER_ID
        </cfquery>
    <cfelseif arguments.member_type eq 'partner'>
        <cfquery name="GET_MEMBER_SMS" datasource="#arguments.dsn_type#">
         SELECT 
             COMPANY_PARTNER.PARTNER_ID,
             COMPANY_PARTNER.COMPANY_PARTNER_NAME+' '+COMPANY_PARTNER.COMPANY_PARTNER_SURNAME AS MEMBER_NAME,
             COMPANY.COMPANY_ID,
             COMPANY.NICKNAME
		FROM 
			#dsn_alias#.COMPANY_PARTNER COMPANY_PARTNER,	
			#dsn_alias#.COMPANY COMPANY
        WHERE 
           COMPANY.COMPANY_ID=COMPANY_PARTNER.COMPANY_ID AND
           COMPANY_PARTNER.PARTNER_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.member_id#">
        </cfquery>
    <cfelseif arguments.member_type eq 'consumer'>
        <cfquery name="GET_MEMBER_SMS" datasource="#arguments.dsn_type#">
            SELECT
               CONSUMER_ID,
               CONSUMER_NAME,
               CONSUMER_SURNAME,
               CONSUMER_NAME+' '+CONSUMER_SURNAME AS MEMBER_NAME,
               '' NICKNAME
            FROM
				#dsn_alias#.CONSUMER CONSUMER
            WHERE 
                CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.member_id#">
        </cfquery>
    <cfelseif arguments.member_type eq 'employee'>
    	 <cfquery name="GET_MEMBER_SMS" datasource="#arguments.dsn_type#">
            SELECT
               EMPLOYEE_ID,
				EMPLOYEE_NAME+' '+EMPLOYEE_SURNAME AS MEMBER_NAME,
               '' NICKNAME
            FROM
				#dsn_alias#.EMPLOYEES EMPLOYEES
            WHERE 
                EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.member_id#">
        </cfquery>
    </cfif>
    
    <cfif find('[VAR_PAPER_NUMBER]',arguments.sms_body) and len(arguments.paper_type) and len(arguments.paper_id)>
        <!--- msjda [VAR_PAPER_NUMBER] değişkeni var ve belge tip ve id geldi ise belge bulunuyor --->
		<cfif arguments.paper_type eq 1><!--- SİPARİŞ --->
            <cfquery name="GET_PAPER" datasource="#arguments.dsn_type#">
                SELECT ORDER_ID PAPER_ID, ORDER_NUMBER PAPER_NUMBER FROM #dsn3_alias#.ORDERS ORDERS WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.paper_id#">
            </cfquery>
        <cfelseif arguments.paper_type eq 2><!--- İRSALİYE --->
            <cfquery name="GET_PAPER" datasource="#arguments.dsn_type#">
                SELECT SHIP_ID PAPER_ID, SHIP_NUMBER PAPER_NUMBER FROM #dsn2_alias#.SHIP SHIP WHERE SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.paper_id#">
            </cfquery>
        <cfelseif arguments.paper_type eq 3><!--- FATURA --->
            <cfquery name="GET_PAPER" datasource="#arguments.dsn_type#">
                SELECT INVOICE_ID PAPER_ID, INVOICE_NUMBER PAPER_NUMBER FROM #dsn2_alias#.INVOICE INVOICE WHERE INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.paper_id#">
            </cfquery>
        <cfelseif arguments.paper_type eq 4><!--- ÇEK --->
            <cfquery name="GET_PAPER" datasource="#arguments.dsn_type#">
                SELECT CHEQUE.CHEQUE_ID PAPER_ID,CHEQUE.CHEQUE_NO PAPER_NUMBER FROM #dsn2_alias#.CHEQUE CHEQUE WHERE CHEQUE.CHEQUE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.paper_id#">
            </cfquery>
        <cfelseif arguments.paper_type eq 5><!--- SENET --->
            <cfquery name="GET_PAPER" datasource="#arguments.dsn_type#">
                SELECT VOUCHER.VOUCHER_ID PAPER_ID, VOUCHER.VOUCHER_NO PAPER_NUMBER FROM #dsn2_alias#.VOUCHER VOUCHER WHERE VOUCHER.VOUCHER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.paper_id#">
            </cfquery>
        <cfelseif arguments.paper_type eq 6><!--- CAĞRI MERKEZİ BAŞVURUSU --->
            <cfquery name="GET_PAPER" datasource="#arguments.dsn_type#">
                SELECT SERVICE_ID PAPER_ID, SERVICE_NO PAPER_NUMBER FROM #dsn_alias#.G_SERVICE G_SERVICE WHERE SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.paper_id#">
            </cfquery>
        <cfelseif arguments.paper_type eq 7><!--- SERVİS BAŞVURUSU --->
            <cfquery name="GET_PAPER" datasource="#arguments.dsn_type#">
                SELECT SERVICE_ID PAPER_ID, SERVICE_NO PAPER_NUMBER FROM #dsn3_alias#.SERVICE SERVICE WHERE SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.paper_id#">
            </cfquery>
        <cfelseif arguments.paper_type eq 8><!--- SİSTEM --->
            <cfquery name="GET_PAPER" datasource="#arguments.dsn_type#">
                SELECT SUBSCRIPTION_ID PAPER_ID, SUBSCRIPTION_NO PAPER_NUMBER FROM #dsn3_alias#.SUBSCRIPTION_CONTRACT SUBSCRIPTION_CONTRACT WHERE SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.paper_id#">
            </cfquery>	
        </cfif>
    </cfif>
    <cfif find('[VAR_CHEQUE_REMAINDER]',arguments.sms_body)>
        <cfquery name="GET_CHEQUE" datasource="#arguments.dsn_type#">
            SELECT SUM(CHEQUE_VALUE) CHEQUE_REMAINDER FROM #dsn2_alias#.CHEQUE CHEQUE WHERE CHEQUE_STATUS_ID IN(1,2) AND CHEQUE_DUEDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(now())#">
            <cfif arguments.member_type eq 'company'>
                AND COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_MEMBER_SMS.COMPANY_ID#">
			<cfelseif arguments.member_type eq 'partner'>
                AND COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_MEMBER_SMS.COMPANY_ID#">
            <cfelseif arguments.member_type eq 'consumer'>
                AND CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.member_id#">
            <cfelse>
                AND 1=0
            </cfif>
        </cfquery>
    </cfif>
    <cfif find('[VAR_VOUCHER_REMAINDER]',arguments.sms_body)>
        <cfquery name="GET_VOUCHER" datasource="#arguments.dsn_type#">
            SELECT SUM(VOUCHER_VALUE) VOUCHER_REMAINDER FROM #dsn2_alias#.VOUCHER VOUCHER WHERE VOUCHER_STATUS_ID IN(1,2) AND VOUCHER_DUEDATE <= #createodbcdatetime(now())#
            <cfif arguments.member_type eq 'company'>
                AND COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_MEMBER_SMS.COMPANY_ID#">
			<cfelseif arguments.member_type eq 'partner'>
                AND COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_MEMBER_SMS.COMPANY_ID#">
            <cfelseif arguments.member_type eq 'consumer'>
                AND CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.member_id#">
            <cfelse>
                AND 1=0
            </cfif>
        </cfquery>
    </cfif>
    
    <cfif find('[VAR_MEMBER_REMAINDER]',arguments.sms_body)>
        <cfif arguments.member_type eq 'partner' or arguments.member_type eq 'company'>
            <cfquery name="GET_REMAINDER" datasource="#arguments.dsn_type#">
               SELECT
					SUM(BORC-ALACAK) MEMBER_REMAINDER
				FROM
				(
					SELECT
						ACTION_VALUE AS BORC,
						0 AS ALACAK
					FROM
						#dsn2_alias#.CARI_ROWS
					WHERE
						(
							DUE_DATE <= CASE WHEN (ACTION_TYPE_ID NOT IN (91,94,98,101,241)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(now())# "> ELSE DUE_DATE END OR
							DUE_DATE IS NULL
						)
						AND (ACTION_DATE <= CASE WHEN (ACTION_TYPE_ID IN (91,94,98,101,241)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(now())# "> ELSE ACTION_DATE END)
						AND TO_CMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_MEMBER_SMS.COMPANY_ID#">
					UNION ALL

					SELECT
						0 AS BORC,
						ACTION_VALUE AS ALACAK
					FROM
						#dsn2_alias#.CARI_ROWS
					WHERE
						(
							DUE_DATE <= CASE WHEN (ACTION_TYPE_ID NOT IN (90,95,97,108,241)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(now())# "> ELSE DUE_DATE END OR
							DUE_DATE IS NULL
						)
						AND (ACTION_DATE <= CASE WHEN (ACTION_TYPE_ID IN (90,95,97,108,241)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(now())# "> ELSE ACTION_DATE END)
						AND FROM_CMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_MEMBER_SMS.COMPANY_ID#">
				)T1
            </cfquery>
        <cfelseif arguments.member_type eq 'consumer'>
            <cfquery name="GET_REMAINDER" datasource="#arguments.dsn_type#">
               
			   SELECT
					SUM(BORC-ALACAK) MEMBER_REMAINDER
				FROM
				(
					SELECT
						ACTION_VALUE AS BORC,
						0 AS ALACAK
					FROM
						#dsn2_alias#.CARI_ROWS
					WHERE
						(
							DUE_DATE <= CASE WHEN (ACTION_TYPE_ID NOT IN (91,94,98,101,241)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(now())# "> ELSE DUE_DATE END OR
							DUE_DATE IS NULL
						)
						AND (ACTION_DATE <= CASE WHEN (ACTION_TYPE_ID IN (91,94,98,101,241)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(now())# "> ELSE ACTION_DATE END)
						AND TO_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_MEMBER_SMS.CONSUMER_ID#">
					UNION ALL
					SELECT
						0 AS BORC,
						ACTION_VALUE AS ALACAK
					FROM
						#dsn2_alias#.CARI_ROWS
					WHERE
						(
							DUE_DATE <= CASE WHEN (ACTION_TYPE_ID NOT IN (90,95,97,108,241)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(now())# "> ELSE DUE_DATE END OR
							DUE_DATE IS NULL
						)
						AND (ACTION_DATE <= CASE WHEN (ACTION_TYPE_ID IN (90,95,97,108,241)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(now())# "> ELSE ACTION_DATE END)
						AND FROM_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_MEMBER_SMS.CONSUMER_ID#">
				)T1
            </cfquery>	
        <cfelse>
            <cfset GET_REMAINDER.MEMBER_REMAINDER=0>
        </cfif>
    </cfif>
    
    <cfif find('[VAR_MY_COMPANY_NAME]',arguments.sms_body)>
        <cfquery name="GET_MY_COMPANY" datasource="#arguments.dsn_type#">
            SELECT NICK_NAME MY_COMPANY_NAME FROM #dsn_alias#.OUR_COMPANY OUR_COMPANY WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
        </cfquery>	
    </cfif>
    
    <cfif find('[VAR_MY_NAME]',arguments.sms_body)>
        <cfquery name="GET_MY_NAME" datasource="#arguments.dsn_type#">
            SELECT EMPLOYEE_NAME, EMPLOYEE_SURNAME FROM #dsn_alias#.EMPLOYEES EMPLOYEES WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
        </cfquery>	
    </cfif>
    
    <cfscript>
        sms_msg=arguments.sms_body;
        if(isdefined('GET_MEMBER_SMS') and find('[VAR_COMPANY_NAME]',sms_msg))//üye şirket ismi
            sms_msg=replace(sms_msg,'[VAR_COMPANY_NAME]','#GET_MEMBER_SMS.NICKNAME#','all');
        if(isdefined('GET_MEMBER_SMS') and find('[VAR_MEMBER_NAME]',sms_msg))//üye şirketi çalışan ismi
            sms_msg=replace(sms_msg,'[VAR_MEMBER_NAME]','#GET_MEMBER_SMS.MEMBER_NAME#','all');
        if(isdefined('GET_PAPER') and find('[VAR_PAPER_NUMBER]',sms_msg))//belge numarası
            sms_msg=replace(sms_msg,'[VAR_PAPER_NUMBER]','#GET_PAPER.PAPER_NUMBER#','all');
        if(isdefined('GET_CHEQUE') and find('[VAR_CHEQUE_REMAINDER]',sms_msg))//vadesi gelmiş çek tutarı
            sms_msg=replace(sms_msg,'[VAR_CHEQUE_REMAINDER]','#TLFormat(GET_CHEQUE.CHEQUE_REMAINDER)# #session.ep.money#','all');
        if(isdefined('GET_VOUCHER') and find('[VAR_VOUCHER_REMAINDER]',sms_msg))//vadesi gelmiş senet tutarı
            sms_msg=replace(sms_msg,'[VAR_VOUCHER_REMAINDER]','#TLFormat(GET_VOUCHER.VOUCHER_REMAINDER)# #session.ep.money#','all');
        if(isdefined('GET_REMAINDER') and find('[VAR_MEMBER_REMAINDER]',sms_msg))//vadesi gelmiş bakiye tutarı
            sms_msg=replace(sms_msg,'[VAR_MEMBER_REMAINDER]','#TLFormat(GET_REMAINDER.MEMBER_REMAINDER)# #session.ep.money#','all');
        if(isdefined('GET_MY_COMPANY') and find('[VAR_MY_COMPANY_NAME]',sms_msg))//bizim şirket ismi
            sms_msg=replace(sms_msg,'[VAR_MY_COMPANY_NAME]','#GET_MY_COMPANY.MY_COMPANY_NAME#','all');
        if(isdefined('GET_MY_NAME') and find('[VAR_MY_NAME]',sms_msg))//sms yollayanın adı
            sms_msg=replace(sms_msg,'[VAR_MY_NAME]','#GET_MY_NAME.EMPLOYEE_NAME# #GET_MY_NAME.EMPLOYEE_SURNAME#','all');	
    </cfscript>
	<cfreturn sms_msg>
</cffunction>

<cffunction name="get_delete_session" hint="Session Temizler">
	<cfargument name="var_" required="false" type="string">
	<cfscript>
		if (isdefined("arguments.var_") and len(arguments.var_))
		{
			if (isdefined("session.#arguments.var_#")) session = structdelete(session, "#arguments.var_#");
			if (isdefined("session.#arguments.var_#_id_comp")) session = structdelete(session,"#arguments.var_#_id_comp");
			if (isdefined("session.#arguments.var_#_id_person")) session = structdelete(session,"#arguments.var_#_id_person");
			if (isdefined("session.#arguments.var_#_id_consumer")) session = structdelete(session,"#arguments.var_#_id_consumer");
			if (isdefined("session.#arguments.var_#_discount")) session = structdelete(session,"#arguments.var_#_discount");
			if (isdefined("session.#arguments.var_#_name_person")) session = structdelete(session,"#arguments.var_#_name_person");
			if (isdefined("session.#arguments.var_#_person")) session = structdelete(session,"#arguments.var_#_person");
			if (isdefined("session.#arguments.var_#_currency")) session = structdelete(session, "#arguments.var_#_currency");
			if (isdefined("session.#arguments.var_#_sa_discount")) session = structdelete(session, "#arguments.var_#_sa_discount");
			if (isdefined("session.#arguments.var_#_total")) session = structdelete(session,"#arguments.var_#_total");
			if (isdefined("session.#arguments.var_#_net_total")) session = structdelete(session,"#arguments.var_#_net_total");
			if (isdefined("session.#arguments.var_#_kdvlist")) session = structdelete(session,"#arguments.var_#_kdvlist");
			if (isdefined("session.#arguments.var_#_kdvpricelist")) session = structdelete(session,"#arguments.var_#_kdvpricelist");
			if (isdefined("session.#arguments.var_#_total_tax")) session = structdelete(session,"#arguments.var_#_total_tax");
			if (isdefined("session.#arguments.var_#_upd")) session = structdelete(session,"#arguments.var_#_upd");
			if (isdefined("session.#arguments.var_#_other_money")) session = structdelete(session,"#arguments.var_#_other_money");
			if (isdefined("session.#arguments.var_#_other_money_value")) session = structdelete(session,"#arguments.var_#_other_money_value");
			if (isdefined("session.#arguments.var_#_prom_list")) session = structdelete(session,"#arguments.var_#_prom_list");
			if (isdefined("session.#arguments.var_#_name_cari")) session = structdelete(session,"#arguments.var_#_name_cari");	
			if (isdefined("session.check_purchase_upd")) session = structdelete(session,"check_purchase_upd");
			if (isdefined("session.check_purchase")) session = structdelete(session,"check_purchase"); 
			if (isdefined("session.check_upd")) session = structdelete(session,"check_upd");
			if (isdefined("session.check")) session = structdelete(session,"check");			
			if (isdefined("session.method_id_purchase_upd")) session = structdelete(session,"consumer_id_purchase_upd");
			if (isdefined("session.method_id")) session = structdelete(session,"method_id"); 
			if (isdefined("session.store")) session = structdelete(session,"store");
			if (isdefined("session.store_id")) session = structdelete(session,"store_id");
			if (isdefined("session.store_id_upd")) session = structdelete(session,"store_id_upd");
			if (isdefined("session.store_id_purchase")) session = structdelete(session,"store_id_purchase");
			if (isdefined("session.upd_id_invoice_sale")) session = structdelete(session,"upd_id_invoice_sale");
			if (isdefined("session.ship_order_row_list")) session = structdelete(session,"session.ship_order_row_list"); 
			if (isdefined("session.LOCATION_ID")) session = structdelete(session,"LOCATION_ID");
			if (isdefined("session.LOCATION_ID_PURCHASE_UPD")) session = structdelete(session,"LOCATION_ID_PURCHASE_UPD");				
			if (isdefined("session.liste_purchase_upd")) session = structdelete(session,"liste_purchase_upd");
			if (isdefined("session.liste_sale")) session = structdelete(session,"liste_sale");
			if (isdefined("session.liste_puchase")) session = structdelete(session,"liste_puchase");			
			if (isdefined("session.LISTE_SALE_upd")) session = structdelete(session,"LISTE_SALE_upd");
			if (isdefined("session.comp_id")) session = structdelete(session,"comp_id");
			if (isdefined("session.consumer_id")) session = structdelete(session,"consumer_id");
			if (isdefined("session.partner_id_purchase_upd")) session = structdelete(session,"partner_id_purchase_upd");
			if (isdefined("session.consumer_id_purchase_upd")) session = structdelete(session,"consumer_id_purchase_upd");

		}
		if (isdefined("session.rate1")) session = structdelete(session,"rate1");
		if (isdefined("session.rate2")) session = structdelete(session,"rate2");
		if (isdefined("session.count")) session = structdelete(session,"count"); 
	</cfscript>
</cffunction>

<cffunction name="f_kur_ekle">
	<!---
		by : Aysenur 20060215
		notes : kur bilgisini gosterir.
		usage :
			process_type:1 upd 0 add
			action_table_name:kur bilgilerinin tutulduğu tablo
			action_table_dsn:kur bilgilerinin tutulduğu tablonun oldugu dsn
			base_value:formdaki sistem para biriminde girilen tutar input değeri
			other_money_value:formdaki diğer döviz biriminde girilen döviz tutar input değeri
			form_name:islemin yapıldıgı formun adı
			select_input:formda seçilen hesap kasa vs nin para birimi
			rate_purchase:kur degerleri alis degeri olarak gelmesi istenirse kullanilir.Default olarak 0.Bu tazr kullanımlarda 1 olarak gonderilmeli BK20100223
		orn:<cfscript>
				f_kur_ekle(process_type:0,base_value:'ACTION_VALUE',other_money_value:'OTHER_CASH_ACT_VALUE',form_name:'add_gidenh');
				f_kur_ekle(action_id=attributes.id,process_type:1,base_value:'ACTION_VALUE',other_money_value:'OTHER_CASH_ACT_VALUE',form_name:'upd_gidenh',action_table_name:'BANK_ACTION_MONEY',action_table_dsn:'#dsn2#',select_input:'action_to_account_id');
			</cfscript>
	--->
	<cfargument name="action_id">
	<cfargument name="action_table_name">
	<cfargument name="action_table_dsn">
	<cfargument name="is_disable" default="0">
	<cfargument name="process_type" required="true">
	<cfargument name="base_value" required="true">
	<cfargument name="other_money_value" required="true">
	<cfargument name="form_name" required="true">
	<cfargument name="select_input" required="true">
	<cfargument name="rate_purchase" default="0">
	<cfargument name="selected_money" default="">
	<cfargument name="call_function" default="">
	<cfquery name="get_standart_process_money" datasource="#dsn#"><!--- muhasebe doneminden standart islem dövizini alıyor --->
		SELECT * FROM SETUP_PERIOD WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_bsk_period_id#">
	</cfquery>
	<cfif arguments.process_type eq 1>
		<cfquery name="get_money_bskt" datasource="#arguments.action_table_dsn#">
			SELECT * FROM #arguments.action_table_name# WITH (NOLOCK) WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#"> ORDER BY ACTION_MONEY_ID
		</cfquery>
		<cfif not get_money_bskt.recordcount>
			<cfquery name="get_money_bskt" datasource="#DSN#">
				SELECT MONEY AS MONEY_TYPE,0 AS IS_SELECTED,* FROM SETUP_MONEY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_bsk_comp_id#"> AND PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_bsk_period_id#"> AND MONEY_STATUS = 1 ORDER BY MONEY_ID
			</cfquery>
		</cfif>
	<cfelse>
		<cfquery name="get_money_bskt" datasource="#DSN#">
			SELECT MONEY AS MONEY_TYPE,RATE1,<cfif arguments.rate_purchase eq 0>RATE2<cfelse>RATE3 RATE2</cfif>,0 AS IS_SELECTED FROM SETUP_MONEY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_bsk_comp_id#"> AND PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_bsk_period_id#"> AND MONEY_STATUS = 1 ORDER BY MONEY_ID
		</cfquery>
	</cfif>
	<cfset str_money_bskt_found = true>
	<input type="hidden" id="kur_say" name="kur_say" value="<cfoutput>#get_money_bskt.recordcount#</cfoutput>">
	<input type="hidden" id="money_type" name="money_type" value="<cfoutput>#arguments.selected_money#</cfoutput>">
	<input type="hidden" id="system_amount" name="system_amount" value="">
	<cfoutput>
	<cfif IsQuery(get_standart_process_money) and len(get_standart_process_money.standart_process_money)><!--- muhasebe doneminden standart islem dövizi işlemleri için --->
		<cfset default_basket_money_=get_standart_process_money.standart_process_money>
	<cfelseif len(str_money_bskt2)>
		<cfset default_basket_money_=str_money_bskt2>
	<cfelse>
		<cfset default_basket_money_=str_money_bskt_main>
	</cfif>
    <table>
        <cfloop query="get_money_bskt">
        	<tr>
				<cfif len(arguments.selected_money) and arguments.selected_money eq money_type>
                    <cfset is_selected_ = 1>
                <cfelse>
                    <cfset is_selected_ = is_selected>
                </cfif>
                <cfif is_selected_>
                    <cfset sepet_rate1 = rate1>
                    <cfset sepet_rate2 = rate2>
                    <cfset str_money_bskt_ = money_type>
                    <cfset str_money_bskt_found = false>
                <cfelseif str_money_bskt_found and money_type eq default_basket_money_>
                    <cfset sepet_rate1 = rate1>
                    <cfset sepet_rate2 = rate2>
                    <cfset str_money_bskt_ = money_type>
                    <cfset str_money_bskt_found = false>
                </cfif>
                <input type="hidden" id="hidden_rd_money_#currentrow#" name="hidden_rd_money_#currentrow#" value="#money_type#">
                <input type="hidden" id="txt_rate1_#currentrow#" name="txt_rate1_#currentrow#" value="#rate1#">
                <cfif session.ep.rate_valid eq 1>
                    <cfset readonly_info = "yes">
                <cfelse>
                    <cfset readonly_info = "no">
                </cfif>
                <cfif money_type eq session.ep.money>
                    <td><input type="radio" name="rd_money" id="rd_money" <cfif arguments.is_disable eq 1>disabled</cfif> value="#currentrow#" onClick="kur_ekle_f_hesapla('#arguments.select_input#');" <cfif isDefined('str_money_bskt_') and str_money_bskt_ eq money_type>checked</cfif>></td>
                    <td>#money_type# #TLFormat(rate1,0)#/</td>
                    <td><input type="text" id="txt_rate2_#currentrow#" name="txt_rate2_#currentrow#" <cfif readonly_info>readonly</cfif> value="#TLFormat(rate2,rate_round_num_info)#" style="width:65px;" readonly=yes class="box"></td>
                <cfelse>
                    <td><input type="radio" name="rd_money" id="rd_money" <cfif arguments.is_disable eq 1>disabled</cfif> value="#currentrow#" onClick="kur_ekle_f_hesapla('#arguments.select_input#');" <cfif isDefined('str_money_bskt_') and str_money_bskt_ eq money_type>checked</cfif>></td>
                    <td>#money_type# #TLFormat(rate1,0)#/</td>
                    <td><input type="text" id="txt_rate2_#currentrow#" name="txt_rate2_#currentrow#" <cfif readonly_info>readonly</cfif> value="#TLFormat(rate2,rate_round_num_info)#" style="width:65px;" class="box" onkeyup="return(FormatCurrency(this,event,'#rate_round_num_info#'));" onBlur="if(this.value != '' && filterNum(this.value,'#rate_round_num_info#') <=0) this.value=commaSplit(1);kur_ekle_f_hesapla('#arguments.select_input#');"></td>
                </cfif>
            </tr>
        </cfloop>
    </table>
	<script type="text/javascript">
		//document.#arguments.form_name#.money_type.value='#str_money_bskt#';
		function kur_ekle_f_hesapla(select_input,doviz_tutar,kur_yok)
		{
			var process_cat_ = document.getElementById('process_cat').options[document.getElementById('process_cat').selectedIndex].value;
			var IS_PROCESS_CURRENCY = '';
			
			if(process_cat_ != '')
			{
				url_= '/V16/settings/cfc/processCat.cfc?method=getProcessCat';
				$.ajax({                                                                                             
					url: url_,
					dataType: "text",
					data: {process_cat: process_cat_},
					cache: false,
					async: false,
					success: function(read_data) {
						data_ = jQuery.parseJSON(read_data.replace('//',''));
						if(data_.DATA.length != 0)
						{
							$.each(data_.DATA,function(i){
								IS_PROCESS_CURRENCY = data_.DATA[i][0];		//IS_PROCESS_CURRENCY
							});
						}
					}
				});
			}
			
			if(IS_PROCESS_CURRENCY != true)
			{
				<cfif len(arguments.call_function)>#arguments.call_function#();</cfif>
				if(!doviz_tutar) doviz_tutar=false;<!--- doviz_tutar:true ise edit edilen input doviz inputu imis --->
				if(document.getElementById(select_input) == undefined || document.getElementById(select_input).value == '') return false;//eğerki kasada seçilecek hesap var ise....
				if(document.getElementById('currency_id') != undefined)
					var currency_type = document.getElementById('currency_id').value;
				else
					var currency_type = eval('document.#arguments.form_name#.'+select_input+'.options[document.#arguments.form_name#.'+select_input+'.selectedIndex]').value;
				
				var other_money_value_eleman= eval('document.#arguments.form_name#.#arguments.other_money_value#');
				var temp_act,temp_base_act,rate1_eleman,rate2_eleman;
				if(doviz_tutar && ( other_money_value_eleman.value.length==0 || filterNum(other_money_value_eleman.value)==0) )
				{<!--- formdaki doviz input edit edilmis ama bos veya sifir gonderilmisse geri donsun --->
					other_money_value_eleman.value = '';
					return false;
				}
				if(!doviz_tutar && eval('document.#arguments.form_name#.#arguments.base_value#.value') != "" && currency_type != "")
				{
					if(document.getElementById('currency_id') != undefined)
						currency_type = document.getElementById('currency_id').value;
					else
						currency_type = list_getat(currency_type,2,';');
					for(var i=1;i<=document.#arguments.form_name#.kur_say.value;i++)
					{
						rate1_eleman = filterNum(eval('document.#arguments.form_name#.txt_rate1_' + i).value,8);
						rate2_eleman = filterNum(eval('document.#arguments.form_name#.txt_rate2_' + i).value,8);
						if( eval('document.#arguments.form_name#.hidden_rd_money_'+i).value == currency_type)
						{
							temp_act=filterNum(document.#arguments.form_name#.#arguments.base_value#.value)*rate2_eleman/rate1_eleman;
							document.#arguments.form_name#.system_amount.value = commaSplit(temp_act,'#rate_round_num_info#');
						}
					}
					if(document.#arguments.form_name#.kur_say.value == 1)
					{
						for(var i=1;i<=document.#arguments.form_name#.kur_say.value;i++)
						{
							rate1_eleman = filterNum(eval('document.#arguments.form_name#.txt_rate1_' + i).value,'#rate_round_num_info#');
							rate2_eleman = filterNum(eval('document.#arguments.form_name#.txt_rate2_' + i).value,'#rate_round_num_info#');
							if( eval('document.#arguments.form_name#.rd_money.checked'))
							{
								if(eval('document.#arguments.form_name#.hidden_rd_money_'+i).value == currency_type)
									other_money_value_eleman.value = commaSplit(filterNum(document.#arguments.form_name#.#arguments.base_value#.value));
								else
									other_money_value_eleman.value = commaSplit(filterNum(document.#arguments.form_name#.system_amount.value,4)*(rate1_eleman/rate2_eleman));
								document.#arguments.form_name#.money_type.value = eval('document.#arguments.form_name#.hidden_rd_money_'+i).value;
								document.#arguments.form_name#.system_amount.value = commaSplit(filterNum(document.#arguments.form_name#.system_amount.value),'#rate_round_num_info#');
							}
						}	
					}
					else
					{
						if(kur_yok != undefined && kur_yok == 1){
							var selectedIndex = eval('document.#arguments.form_name#.ACTION_CURRENCY_ID').selectedIndex + 1;
							rate1_eleman = filterNum(eval('document.#arguments.form_name#.txt_rate1_' + selectedIndex + '').value,'#rate_round_num_info#');
							rate2_eleman = filterNum(eval('document.#arguments.form_name#.txt_rate2_' + selectedIndex + '').value,'#rate_round_num_info#');
							
							var selectedIndex_other = eval('document.#arguments.form_name#.ACTION_CURRENCY_ID_').selectedIndex + 1;
							rate1_eleman_other = filterNum(eval('document.#arguments.form_name#.txt_rate1_' + selectedIndex_other + '').value,'#rate_round_num_info#');
							rate2_eleman_other = filterNum(eval('document.#arguments.form_name#.txt_rate2_' + selectedIndex_other + '').value,'#rate_round_num_info#');
							if((eval('document.#arguments.form_name#.ACTION_CURRENCY_ID').value).split(';')[1] == (eval('document.#arguments.form_name#.ACTION_CURRENCY_ID_').value).split(';')[1])
								other_money_value_eleman.value = commaSplit(filterNum(document.#arguments.form_name#.#arguments.base_value#.value));
							else
							other_money_value_eleman.value = commaSplit(filterNum(document.#arguments.form_name#.#arguments.base_value#.value,4)*(rate2_eleman/rate2_eleman_other));
							document.#arguments.form_name#.money_type.value = eval('document.#arguments.form_name#.hidden_rd_money_' + selectedIndex + '').value;
						}else{
							for(var i=1;i<=document.#arguments.form_name#.kur_say.value;i++)
							{
								rate1_eleman = filterNum(eval('document.#arguments.form_name#.txt_rate1_' + i).value,'#rate_round_num_info#');
								rate2_eleman = filterNum(eval('document.#arguments.form_name#.txt_rate2_' + i).value,'#rate_round_num_info#');
								if( eval('document.#arguments.form_name#.rd_money['+(i-1)+'].checked'))
								{
									if(eval('document.#arguments.form_name#.hidden_rd_money_'+i).value == currency_type)
										other_money_value_eleman.value = commaSplit(filterNum(document.#arguments.form_name#.#arguments.base_value#.value));
									else
										other_money_value_eleman.value = commaSplit(filterNum(document.#arguments.form_name#.system_amount.value,4)*(rate1_eleman/rate2_eleman));
									document.#arguments.form_name#.money_type.value = eval('document.#arguments.form_name#.hidden_rd_money_'+i).value;
									document.#arguments.form_name#.system_amount.value = commaSplit(filterNum(document.#arguments.form_name#.system_amount.value),'#rate_round_num_info#');
								}
							}
						}
					}
				}
				else if(doviz_tutar && document.#arguments.form_name#.#arguments.other_money_value#.value != "" && currency_type != "")
				{
					
					if(document.getElementById('currency_id') != undefined)
						currency_type = document.getElementById('currency_id').value;
					else
						currency_type = list_getat(currency_type,2,';');
					for(var i=1;i<=document.#arguments.form_name#.kur_say.value;i++)
					{
						rate1_eleman = filterNum(eval('document.#arguments.form_name#.txt_rate1_' + i).value,8);
						rate2_eleman = filterNum(eval('document.#arguments.form_name#.txt_rate2_' + i).value,8);
						if( eval('document.#arguments.form_name#.hidden_rd_money_'+i).value == currency_type)
						{		
							temp_act_base = filterNum(document.#arguments.form_name#.#arguments.other_money_value#.value)*rate1_eleman/rate2_eleman;
							temp_act_base_2 = commaSplit(temp_act_base,'#rate_round_num_info#');	
						}
					}
					if(document.#arguments.form_name#.kur_say.value == 1)
					{
						for(var i=1;i<=document.#arguments.form_name#.kur_say.value;i++)
						{
							rate1_eleman = filterNum(eval('document.#arguments.form_name#.txt_rate1_' + i).value,'#rate_round_num_info#');
							rate2_eleman = filterNum(eval('document.#arguments.form_name#.txt_rate2_' + i).value,'#rate_round_num_info#');
							if( eval('document.#arguments.form_name#.rd_money.checked'))
							{
								if(eval('document.#arguments.form_name#.hidden_rd_money_'+i).value == currency_type)
									other_money_value_eleman.value = commaSplit(filterNum(document.#arguments.form_name#.#arguments.other_money_value#.value));
								else
									other_money_value_eleman.value = commaSplit(filterNum(temp_act_base_2,4)*(rate2_eleman/rate1_eleman));
								document.#arguments.form_name#.money_type.value = eval('document.#arguments.form_name#.hidden_rd_money_'+i).value;
							}
						}
					}
					else
					{
						if(kur_yok != undefined && kur_yok == 1){
							var selectedIndex = eval('document.#arguments.form_name#.ACTION_CURRENCY_ID').selectedIndex;
							rate1_eleman = filterNum(eval('document.#arguments.form_name#.txt_rate1_' + (selectedIndex + 1) + '').value,'#rate_round_num_info#');
							rate2_eleman = filterNum(eval('document.#arguments.form_name#.txt_rate2_' + (selectedIndex + 1) + '').value,'#rate_round_num_info#');
							
							var selectedIndex_other = eval('document.#arguments.form_name#.ACTION_CURRENCY_ID_').selectedIndex + 1;
							rate1_eleman_other = filterNum(eval('document.#arguments.form_name#.txt_rate1_' + selectedIndex_other + '').value,'#rate_round_num_info#');
							rate2_eleman_other = filterNum(eval('document.#arguments.form_name#.txt_rate2_' + selectedIndex_other + '').value,'#rate_round_num_info#');
							if((eval('document.#arguments.form_name#.ACTION_CURRENCY_ID').value).split(';')[1] == (eval('document.#arguments.form_name#.ACTION_CURRENCY_ID_').value).split(';')[1])
								document.#arguments.form_name#.#arguments.base_value#.value = commaSplit(filterNum(document.#arguments.form_name#.#arguments.other_money_value#.value));
							else
								document.#arguments.form_name#.#arguments.base_value#.value = commaSplit(filterNum(document.#arguments.form_name#.#arguments.other_money_value#.value,4)*(rate2_eleman_other/rate2_eleman));
							document.#arguments.form_name#.money_type.value = eval('document.#arguments.form_name#.hidden_rd_money_' + (selectedIndex + 1) + '').value;
							document.#arguments.form_name#.system_amount.value = commaSplit(filterNum(document.#arguments.form_name#.system_amount.value),'#rate_round_num_info#');
							
						}else{
							for(var i=1;i<=document.#arguments.form_name#.kur_say.value;i++)
							{
								rate1_eleman = filterNum(eval('document.#arguments.form_name#.txt_rate1_' + i).value,'#rate_round_num_info#');
								rate2_eleman = filterNum(eval('document.#arguments.form_name#.txt_rate2_' + i).value,'#rate_round_num_info#');
								if( eval('document.#arguments.form_name#.rd_money['+(i-1)+'].checked'))
								{
									if(eval('document.#arguments.form_name#.hidden_rd_money_'+i).value == currency_type){
										document.#arguments.form_name#.#arguments.base_value#.value = commaSplit(filterNum(document.#arguments.form_name#.#arguments.other_money_value#.value));
									}
									else{
										document.#arguments.form_name#.#arguments.base_value#.value = commaSplit(filterNum(temp_act_base_2,4)*(rate2_eleman/rate1_eleman));
									}
									document.#arguments.form_name#.money_type.value = eval('document.#arguments.form_name#.hidden_rd_money_'+i).value;
								}
							}
						}
					}				
					for(var i=1;i<=document.#arguments.form_name#.kur_say.value;i++)
					{
						rate1_eleman = filterNum(eval('document.#arguments.form_name#.txt_rate1_' + i).value,8);
						rate2_eleman = filterNum(eval('document.#arguments.form_name#.txt_rate2_' + i).value,8);
						if( eval('document.#arguments.form_name#.hidden_rd_money_'+i).value == currency_type)
						{
							temp_act=filterNum(document.#arguments.form_name#.#arguments.base_value#.value)*rate2_eleman/rate1_eleman;
							document.#arguments.form_name#.system_amount.value = commaSplit(temp_act,'#rate_round_num_info#');
						}
					}
				}
				<cfif len(arguments.call_function)>
					#arguments.call_function#();
				<cfelse>
					document.#arguments.form_name#.#arguments.base_value#.value = commaSplit(filterNum(document.#arguments.form_name#.#arguments.base_value#.value));
					document.#arguments.form_name#.#arguments.other_money_value#.value = commaSplit(filterNum(document.#arguments.form_name#.#arguments.other_money_value#.value));	
					document.#arguments.form_name#.system_amount.value = commaSplit(filterNum(document.#arguments.form_name#.system_amount.value),'#rate_round_num_info#');                                    								
				</cfif>
				return true;
			}
			else
			{
				if(document.#arguments.form_name#.kur_say.value == 1)
				{
					for(var i=1;i<=document.#arguments.form_name#.kur_say.value;i++)
						if( eval('document.#arguments.form_name#.rd_money.checked'))
							document.#arguments.form_name#.money_type.value = eval('document.#arguments.form_name#.hidden_rd_money_'+i).value;
				}
				else
				{
					for(var i=1;i<=document.#arguments.form_name#.kur_say.value;i++)
						if( eval('document.#arguments.form_name#.rd_money['+(i-1)+'].checked'))
							document.#arguments.form_name#.money_type.value = eval('document.#arguments.form_name#.hidden_rd_money_'+i).value;
				}	
			}		
		}
	</script>
	</cfoutput>
</cffunction>
<cffunction name="f_kur_ekle_action">
	<cfargument name="action_id" required="true">
	<cfargument name="action_table_name" required="true">
	<cfargument name="action_table_dsn" required="true">
	<cfargument name="action_table_dsn_alias">
	<cfargument name="transaction_dsn"> <!--- transaction da kullanılan dsn gonderilirr --->
	<cfif not (isdefined('arguments.transaction_dsn') and len(arguments.transaction_dsn))>
		<cfset arguments.transaction_dsn = arguments.action_table_dsn>
		<cfset arguments.action_table_dsn_alias = ''>
	<cfelse>
		<cfset arguments.action_table_dsn_alias = '#arguments.action_table_dsn#.'>
	</cfif>
	<!---
		by : Aysenur 20060215
		notes : kurla ilgili tablolara kayıt atar.
		usage :
			process_type:1 upd 0 add
			action_table_name:kur bilgilerinin atılacagı tablonun adı
			action_table_dsn:kur bilgilerinin atılacagı tablonun oldugu dsn
		örn:<cfscript>
			f_kur_ekle_action(action_id:get_act_id.MAX_ID,action_table_name:'BANK_ACTION_MONEY',action_table_dsn:'#dsn2#');
			f_kur_ekle_action(action_id:URL.ID,action_table_name:'BANK_ACTION_MONEY',action_table_dsn:'#dsn2#');
		</cfscript>
	--->
    <cfquery name="del_money_obj_bskt" datasource="#arguments.transaction_dsn#">
        DELETE FROM 
            #arguments.action_table_dsn_alias##arguments.action_table_name#
        WHERE 
            ACTION_ID=#arguments.action_id#
    </cfquery>
    <cfif isDefined('attributes.kur_say')>
        <cfloop from="1" to="#attributes.kur_say#" index="fnc_i">
            <cfquery name="add_money_obj_bskt" datasource="#arguments.transaction_dsn#">
                INSERT INTO #arguments.action_table_dsn_alias##arguments.action_table_name# 
                (
                    ACTION_ID,
                    MONEY_TYPE,
                    RATE2,
                    RATE1,
                    IS_SELECTED
                )
                VALUES
                (
                    #arguments.action_id#,
                    '#wrk_eval("attributes.hidden_rd_money_#fnc_i#")#',
                    #evaluate("attributes.txt_rate2_#fnc_i#")#,
                    #evaluate("attributes.txt_rate1_#fnc_i#")#,
                    <cfif evaluate("attributes.hidden_rd_money_#fnc_i#") is attributes.money_type>
                        1
                    <cfelse>
                        0
                    </cfif>			
                )
            </cfquery>
        </cfloop>
    </cfif>
</cffunction>
<cffunction name = "getImportExpFormat" returnType = "any" access = "public">
	<cfargument name="fileName" type="string" required="true">

	<cfset download_folder = replace(application.systemParam.systemParam().download_folder,"\","/","all") />
    <cfset upload_folder = replace(application.systemParam.systemParam().upload_folder,"\","/","all") />

	<cftry>
		<cfif FileExists("#download_folder#IEF/standarts/import_example/#arguments.fileName#_#session.ep.language#.html")>
			<cfinclude template="../IEF/standarts/import_example/#arguments.fileName#_#session.ep.language#.html">
		<cfelseif FileExists("#upload_folder#templates/import_example/#arguments.fileName#_#session.ep.language#.html")>
			<cfinclude template="../documents/templates/import_example/#arguments.fileName#_#session.ep.language#.html">
		<cfelse>
			<cf_get_lang dictionary_id='29760.Yardım dosyası bulunamadı. Lütfen sistem yöneticinize ulaşınız'>
		</cfif>
	<cfcatch type="any">
	</cfcatch>
	</cftry>
	
</cffunction>
</cfcomponent>