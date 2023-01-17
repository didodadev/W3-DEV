<cfparam name="attributes.align" default="right">
<cfset Randomize(round(rand()*1000000))/>
<cfparam name="attributes.id" default="speed_#round(rand()*10000000)#">
<cfif isdefined("attributes.product_id")>
	<cfset type_ = 0>
	<cfset islem_id_ = attributes.product_id>
<cfelse>
	<cfset type_ = 1>
	<cfset islem_id_ = attributes.stock_id>
</cfif>
<cfoutput>
	<td id="#attributes.id#">
		<a id="imaj_folder" href="javascript://" onClick="speed_islem_yap(document.getElementById('#attributes.id#'),#islem_id_#,0);"><img id="#attributes.id#_source" src="/images/folder_add_list.gif" border="0" title="<cf_get_lang dictionary_id= '52116.Sepete Ekle'>"></a>
    </td>
</cfoutput>
<script type="text/javascript">
	<cfoutput>
		function speed_urun_ekle(obje,id)
		{
			if(document.getElementById(obje).value == '')
				{
				alert("<cf_get_lang_main no='2146.Miktar Girmelisiniz'>!");
				return false;
				}
			add_speed_basket('#type_#',id,document.getElementById(obje).value);
		}
	</cfoutput>
</script>
