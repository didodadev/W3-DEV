<cfinclude template="xml_data.cfm">
<cfset attributes.mode = 3>
<cfparam name="attributes.keyword" default="">

	<cfquery name="get_xml_files" datasource="#DSN#">
		SELECT * FROM CREATED_XML_FILES
	</cfquery>
<cfform name="search" action="" method="post">
	<div class="col col-12">
		<h3 class="workdevPageHead">Ürün XML Listesi</h3>
	</div> 		
	<div class="row form-inline">
		<div class="form-group">
			<div class="input-group">
				<input type="text" name="keyword" id="keyword" placeholder="<cf_get_lang_main no='48.Filtre'>" value="<cfoutput>#attributes.keyword#</cfoutput>" maxlength="50">
			</div>
		</div>
		<div class="form-group">
			<cf_wrk_search_button>
		</div>
		<div class="form-group">
			<cfoutput>
			<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=protein.popup_create_documentation','medium');" class="btn grey-cascade btn-small icon-pluss margin-left-5"></a>
			</cfoutput>
		</div>
	</div>
</cfform>
<cf_medium_list>
	<thead>
		<tr height="20">
			<th>ID</th>
			<th>XML</th>
			<th>Açıklama</th>
			<th>IP</th>
			<th></th>
		</tr>
	</thead>
	<tbody>
		<cfoutput query="get_xml_files">
			<tr data-id="#xml_file_id#">
				<td data-key>#xml_file_id#</td>
				<td><a href="#file_web_path#product\XML\#file_name#" class="tableyazi" target="_blank">#file_name#</a></td>
				<td>#detail#</td>
				<td>#record_ip#</td>
				<td>
					<a href="#file_web_path#product\XML\#file_name#" target="_blank"><i class="fa fa-file-code-o" style="font-size:16px" title="Ürün XML Dosyası !"></i></a>
					&nbsp;&nbsp;&nbsp;
					<cfsavecontent variable="message">Kayıtlı XML Siliyorsunuz  Emin misiniz!</cfsavecontent>
                    <a href="javascript://" onClick="if (confirm('#message#')) windowopen('#request.self#?fuseaction=protein.emptypopup_del_xml_file&xml_file_id=#xml_file_id#','medium');"><i class="fa fa-minus-circle" style="font-size:16px" title="XML Sil !"></i> </a>
			   </td>
				
			</tr>
		</cfoutput>			 
	</tbody>
</cf_medium_list>	

<!--- Sayfa Popup a alındı --->
<!---
<div class="row">
	<div class="col col-12 uniqueRow">
		<div class="col col-12 col-md-12 col-xs-12 col-sm-12">
			<div class="form-group require">
				<div class="col col-9">
					 
				</div>
				<div class="col col-1"></div>
			</div>
			<div class="col col-12">
				<div class="form-group require">
					<div class="col col-12"><label class="form-label"><cf_seperator id="general" header="Filtre Özellikleri"></label></div>
				</div>
			</div>
			<cfform name="create_documentation" id="create_documentation" action="#request.self#?fuseaction=protein.emptypopup_add_xml_file" enctype="multipart/form-data" method="post">
			<div class="column" id="general">
				<!---<div class="form-group require">
					<div class="col col-2">
						<input type="checkbox" name="category_filter" id="category_filter" value="">&nbsp;&nbsp;&nbsp;Kategorisel Filtrelemeyi Kullan
					</div>
					<div class="col col-4">						
						<select name="category_filter_id" class="form-control" id="category_filter_id" style="width:147px;">
							<option value="">Değiştirmek İçin Tıklayınız</option>
							<option value=""></option>
						</select>		
					</div>
					<div class="col col-6">&nbsp;</div>
				</div>
				<div class="form-group require">
					<div class="col col-2">
						<input type="checkbox" name="brand_filter" id="brand_filter" value="">&nbsp;&nbsp;&nbsp;Markasal Filtrelemeyi Kullan
					</div>
					<div class="col col-4">						
						<select name="brand_filter_id" class="form-control" id="brand_filter_id" style="width:147px;">
							<option value="">Seçmek İçin Tıklayınız</option>
							<option value=""></option>
						</select>		
					</div>
					<div class="col col-6">&nbsp;</div>
				</div>
				<div class="form-group require">
					<div class="col col-2">
						<input type="checkbox" name="entegrasyon_filter" id="entegrasyon_filter" value="">&nbsp;&nbsp;&nbsp;Entegrasyon Filtresi Kullan
					</div>
					<div class="col col-2">						
						<select name="entegrasyon_filter_id" class="form-control" id="entegrasyon_filter_id" style="width:147px;">
							<option value="">Seçmek İçin Tıklayınız</option>
							<option value=""></option>
						</select>		
					</div>
					<div class="col col-8">&nbsp;</div>
				</div>
				<div class="form-group require">
					<div class="col col-2">
						Diğer Filtre Özelliklerini Kullan
					</div>
					<div class="col col-2">						
						<select name="other_filter" class="form-control" id="other_filter" style="width:147px;">
							<option value="">Değiştirmek İçin Tıklayınız</option>
							<option value="">Değiştirmek İçin Tıklayınız</option>
						</select>		
					</div>
					<div class="col col-8">&nbsp;</div>
				</div>
				<div class="form-group require">
					<div class="col col-2">
						Fiyat Hassasiyeti
					</div>
					<div class="col col-2">						
						<input type="text" id="price_accuracy" name="price_accuracy" value="">		
					</div>
					<div class="col col-8">&nbsp;</div>
				</div>
				<div class="form-group require">
					<div class="col col-2">
						Kargo Gönderim Süresi
					</div>
					<div class="col col-2">						
						<input type="text" id="shipping_time" name="shipping_time" value="">		
					</div>
					<div class="col col-8">&nbsp;</div>
				</div><br><br>
				<div class="form-group require">
					<div class="col col-2">&nbsp;</div>
					<div class="col col-8">						
						<p style="text-align:center; font-size:14px;">Veri Alanları</p>		
					</div>
					<div class="col col-2">&nbsp;</div>
				</div><br><br>--->
				<!---<div class="col col-1">
					<input type="checkbox" name="product_ame" id="product_name" value="product_name">&nbsp;ürün ismi 
				</div>--->
				<cfloop from="1" to="#listlen(id_list,'*')#" index="sira">
				<cfoutput>
				<cfif sira eq 1 or sira mod attributes.mode eq 1><div class="form-group require"></cfif>
					<cfset id_ = trim(listgetat(id_list,sira,'*'))>
					<cfset text_ = trim(listgetat(name_list,sira,'*'))>
					<cfset value_ = trim(listgetat(text_name_list,sira,'*'))>
					<div class="col col-1">
						<input type="checkbox" name="#id_#" id="#id_#" value="1" checked>&nbsp;#text_#
					</div>
					<div class="col col-2">						
						<input type="text" id="#id_#_text" name="#id_#_text" value="#value_#">		
					</div>
				<cfif sira eq listlen(id_list,'*') or (sira gte attributes.mode and sira mod attributes.mode eq 0)></div></cfif>
				</cfoutput>
				</cfloop><br><br><br><br>
				<div class="form-group require">
					<div class="col col-1"><p style="font-size:16px;">Çıktı Formatı : </p></div>
					<div class="col col-1">						
						<select name="print_type" class="form-control" id="print_type" style="width:120px;">
							<option value="">XML</option>
						</select>	
					</div>
				</div>
				<div class="form-group require">
					<div class="col col-1"><p style="font-size:12px;">Döküman Ana Etiketi : </p></div>
					<div class="col col-1">						
						<input type="text" name="documentation_main_tag" id="documentation_main_tag" value="">	
					</div>
				</div>
				<!---
				<div class="form-group require">
					<div class="col col-1"><p style="font-size:12px;">Key/Tag Ana Etiketi : </p></div>
					<div class="col col-1">						
						<input type="text" name="key_main_tag" id="key_main_tag" value="">	
					</div>
				</div>
				<div class="form-group require">
					<div class="col col-1"><p style="font-size:12px;">XML namespace url : </p></div>
					<div class="col col-1">						
						<input type="text" name="xml_namespace_url" id="xml_namespace_url" value="">	
					</div>
				</div>
				<div class="form-group require">
					<div class="col col-1"><p style="font-size:12px;">XML namespace-xsi url : </p></div>
					<div class="col col-1">						
						<input type="text" name="xml_namespace_xsi_url" id="xml_namespace_xsi_url" value="">	
					</div>
				
				</div>
				<div class="form-group require">
					<div class="col col-2"><input type="checkbox" name="definition_internal_attributes" id="definition_internal_attributes" value=""><p style="font-size:14px;">Özellikleri iç nitelik olarak tanımlama</p></div>
				</div><br>
				
				<div class="form-group require">
					<div class="col col-1"><p style="font-size:16px;">Parti No : </p></div>
					<div class="col col-1">						
						<select name="part_no" class="form-control" id="part_no" style="width:120px;">
							<option value="">ilk 50000 eleman</option>
							<option value=""></option>
						</select>	
					</div>
				</div><br>
				<p>* 50000 elemandan daha az veri içeren çıktılar için bu kısmı seçmenize gerek yoktur.(örneğin 33334 ürün içeren bir katalog çıktısı alacaksanız bu alanı seçmeyiniz.)</p><br>
				<div class="form-group require">
					<div class="col col-2">
						<input type="radio" name="print" class="form-control" value="only_print"><p style="font-size:12px;">Sadece Çıktı Al</p><br>
						<input type="radio" name="print" class="form-control" value="only_save"><p style="font-size:12px;"> Sadece Kaydet</p><br>
						<input type="radio" name="print" class="form-control" value="save_and_print"><p style="font-size:12px;"> Kaydet ve Çıktı Al</p>
					</div>
					<div class="col col-1">						
						<p style="font-size:12px;">Çıktı Adı :</p> <br><br><br> <p style="font-size:12px;">Açıkalama : </p>
					</div>
					<div class="col col-2">	
						<input type="text" id="print_name" name="print_name" value=""><br><br><br>
						<textarea id="desciription" name="desciription" class="form-control" style="width:230px;height:80px;"> </textarea>
					</div>	
				</div><br>--->
				<div class="form-group require">
					<div class="col col-1">
						<input type="submit" class="btn btn-info" onclick="return control();" value="Gönder">				
					</div>
				</div>
			</div>
			</cfform>
			<!---
			<div class="col col-12">
				<div class="form-group require">
					<div class="col col-12"><label class="form-label"><cf_seperator id="add_permission" header="İzin Ekle"></label></div>
				</div>
			</div>
			<div class="column" id="add_permission">
				<div class="form-group require">
					<div class="col col-1"><p style="font-size:14px;">Bilgi</p></div>
					<div class="col col-4"><p>: Herhangi bir IP veya Üye belirtmemeniz durumunda linki bilen herkes bu çıktıyı alabilecektir.</p></div>
				</div>
				<div class="form-group require">
					<div class="col col-1"><p style="font-size:14px;">IP</p></div>
					<div class="col col-2"><input type="text" id="ip_info" name="ip_info" value=""></div>
				</div>
				<div class="form-group require">
					<div class="col col-1"><p style="font-size:14px;">Üye Email</p></div>
					<div class="col col-2"><input type="text" id="member_email" name="member_email" value=""></div>
				</div>
				<div class="form-group require">
					<div class="col col-1">&nbsp;</div>
					<div class="col col-2">
						<button type="button" class="btn btn-info">Gönder</button>&nbsp;&nbsp;<button type="button" class="btn">Geri Dön</button>
					</div>
				</div>
			</div>--->
			<!---
			<div class="col col-12">
				<div class="form-group require">
					<div class="col col-12"><label class="form-label"><cf_seperator id="permisson_of_print" header="..... için xml çıktısına ait izinler"></label></div>
				</div>
			</div>
			<div class="column" id="permisson_of_print">
				<div class="form-group require">
					<div class="col col-6"><table><tr><td style="border:solid 1px;width:1000px;">&nbsp;</td></tr></table></div>
					<div class="col col-1"><input type="checkbox" id="state" name="state">Durumu</div>
				</div>
				<div class="form-group require">
					<div class="col col-2"><button type="button" class="btn">Yenile</button>&nbsp;&nbsp;<button type="button" class="btn btn-info">Ekle</button>&nbsp;&nbsp;<button type="button" class="btn btn-danger">Sil</button></div>
					<div class="col col-2">&nbsp;</div>
					<div class="col col-4">Kayıt Sayısı</div>
				</div><br>
				
				<div class="form-group require">
					<div class="col col-2"><button type="button" class="btn">Yenile</button>&nbsp;&nbsp;<button type="button" class="btn btn-info">Ekle</button>&nbsp;&nbsp;<button type="button" class="btn btn-danger">Sil</button></div>
					<div class="col col-2">&nbsp;</div>
					<div class="col col-4">Kayıt Sayısı</div>
				</div>--->
			</div>
		</div>
	</div>
</div>--->
<script>
	function control()
	{
		var deger = document.getElementById("documentation_main_tag").value;
		if(deger == '')
		{
			alert("Lütfen XML Dosya İsmi Veriniz!");
			return false;
		}
	}
</script>