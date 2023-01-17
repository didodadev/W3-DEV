<cffile action="read" variable="dosya" file="#index_folder#/#attributes.CustomTagPath#" charset="UTF-8">

<cfset dosya = Replace(dosya,'default','default','all')>
<br /><br />

<cfset controlVariable = 0>
<cfset sayac = 0>
<cfoutput>
	<cfif findNoCase('<cfparam',dosya)>
    	<form name="utCustomTag" method="post" action="#request.self#?fuseaction=objects.utilityCustomTagAction">
        	<input type="text" name="customTagPath" id="customTagPath" value="#attributes.CustomTagPath#" />
			<div class="form-group">
				<label class="col col-2 col-xs-4"><cf_get_lang dictionary_id='45880.Etiket'></label>
                <label class="col col-5 col-xs-4"><cf_get_lang dictionary_id='43116.Default'></label>
                <label class="col col-5 col-xs-4"><cf_get_lang dictionary_id='38794.Değer'></label>
            </div>
            <cfloop condition = "controlVariable eq 0">
            	<cfset sayac = sayac + 1>
                <div class="form-group">
                    <cfset start = findNoCase('<cfparam',dosya)>
                    <cfset finish = findNoCase('>',dosya,start)>
                    <cfset word = toString(mid(dosya,start,finish-start+1))>
                    
                    <cfset beforeAyrac = left(word,findNoCase('default="',word,0)-1)>
                    <cfset afterAyrac = mid(word,findNoCase('default="',word,0),finish-findNoCase('default="',word,0))>
                    
					<cfif findNoCase('default=""',word,0)>
						<cfset paramDefault = ''>
                    <cfelse>
                        <cfset paramDefault = Replace(Replace(Replace(afterAyrac,'"','','all'),'default=','','all'),'>','','all')>
                    </cfif>
        
                    <cfset paramName = Replace(Replace(Replace(Replace(Replace(beforeAyrac,'<','','all'),'cfparam','','all'),'name=','','all'),'"','','all'),'=','','all')>
                    
                    <cfset dosya = Replace(dosya,word,'')>
                    <cfif findNoCase('<cfparam',dosya) eq 0>
                        <cfset controlVariable = 1>
                    </cfif>
                    <label class="col col-2 col-xs-4">
                        #paramName#
                    </label>
                    <div class="col col-5 col-xs-4">
                        <input type="text" name="newDefault#sayac#" value="#paramDefault#" readonly="readonly"/>
                    </div>
                    <div class="col col-5 col-xs-4">
                    	<input type="text" name="newData#sayac#" value="" />
                    </div>   
                </div>
                <input type="hidden" name="extParam#sayac#" value="#paramName#" />
                <input type="hidden" name="extData#sayac#" value="#urlEncodedFormat(word)#"/>
            </cfloop>
            <div class="form-group">
                <div class="col col-12 col-xs-12 text-right">
                	<input type="hidden" name="counter" id="counter" value="#sayac#" />
                    <input type="submit" class="btn green-haze" value="Kaydet"/>
                </div>
            </div>
        </form>
	<cfelse>
    	<cf_get_lang dictionary_id='34607.Parametresiz Custom Tag Kullanımı'>
    </cfif>
</cfoutput>