<style>
	ul {padding: 0px;}
	.col-4{margin-bottom:20px;}
	input[type="button"]{height:auto!important;width:100%;padding:5px;margin-left:0;}
	textarea{resize:none;outline:none;width:100%;height:100%;font-family: 'Roboto';font-size: 11px;border:1px solid #eaeaea;overflow-y:scroll;padding:30px 10px 10px 10px;}
	
	.db-compare{float:left;width:100%;}
	.db-compare .form-group:first-child{margin-top:0!important}
	.db-compare .form-group label{color:#333;margin:0 0 5px 0!important}
	.db-compare input[type="text"], .db_compare input[type="password"], .db_compare select{font-size:12px;color:#333;width:100%;}
	
	.db-compare-body{float:left;width:100%;margin-top:10px;border:1px solid #eaeaea;background-color:#f9f9f9;}
	.db-compare-title{font-size:12px;color:#333;font-weight:bold;padding:10px;border-bottom:1px solid #eaeaea;letter-spacing:1px;}
	.db-compare-content{padding:10px;}
	.db-compare-btn{float:right;background-color:#44b6ae;}
	
	#diffArea .portBox{border:0!important;border-radius:0!important;margin-bottom:0!important;position:relative;box-shadow:0 0 10px #f9f9f9;}
	#diffArea .portBox .portHead{padding:5px 10px!important;background-color:#44b6ae;border:0!important;min-height:inherit!important;font-weight:bold!important;}
	#diffArea .portBox .portHead span{margin:0!important;font-size:13px;font-weight:bold;color:#fff;letter-spacing:1px;}

	.db-abs{display:none;position:absolute;left:0;top:0;width:100%;height:100%;z-index:9;}
	.db-abs-cl{position: absolute;left: 0;top: 0;width: 25px;height: 25px;background: #f9f9f9;border: 1px solid #eaeaea;text-align: center;line-height: 25px;color: #555;}

	.db_tables{padding:10px!important;margin:0!important;border:1px solid #eaeaea;max-height:450px;overflow-y:scroll;}
	.db_tables::-webkit-scrollbar {width: 0;}
	.db_tables li input[type="checkbox"]{margin-top:0!important;margin-right:3px;}

	.db_tables li{background: #f9f9f9;border:1px solid #eaeaea;padding:5px 10px;display: flex;display: -webkit-box;display: -moz-box;display: -ms-flexbox;display: -webkit-flex; flex-direction: row;flex-wrap:wrap;align-items:center;margin-bottom:10px!important;letter-spacing:1px;border-radius:4px;}
	.db_tables li a{flex:1;font-size:11px;color:#333!important;word-break:break-word;}

	.db_tables ul{margin-top:10px;flex-basis:100%;padding:0 10px!important;}
	.db_tables ul li{margin-bottom:5px!important;border:0!important;}
	.db_tables li label{font-size:10px;color:#333;margin:0!important;}

	.db_tables > li{transition:.4s;}
	.db_tables > li:hover{background-color:#eee;transition:.4s;}

	.type_1 {border-left: 5px solid #F44336!important;}
	.type_2 {border-left: 5px solid #00BCD4!important;}
	.db_all_chk {margin:0 5px;}
	.db_chk {margin:0 5px;}

	.db-compare-info{font-size:14px;color:#333;}

	.db-compare-run{float:left;width:100%;background-color:#f9f9f9;border:1px solid #eaeaea;border-top:0;padding:10px;box-shadow:0 0 10px #f9f9f9}
	.generate-btn{float:left;letter-spacing:1px;width:auto!important;margin-right:5px;font-weight:bold;padding:5px 10px!important;}
	.run-btn{float:left;letter-spacing:1px;width:auto!important;font-weight:bold;padding:5px 10px!important;}
	@media only screen and (max-width:767px){
		.db-compare{margin-bottom:10px;}
	}
</style>
<div class="row">
	<div class="col col-12 col-xs-12">
		<h3><cf_get_lang dictionary_id="51039.Şema Karşılaştırması"> </h3>
	</div>
</div>
<div class="row">
	<div class="col col-3 col-xs-12">
		<div class="db-compare">
			<div class="form-group">
				<input type = "button" value = "<cf_get_lang dictionary_id="64467.Veri Kaynağını Getir">" onClick = "getDatasources();">
			</div>
			<div class="db-compare-body">
				<div class="db-compare-title">
					<cf_get_lang dictionary_id="64468.Veri Kaynakları">
				</div>
				<div class="db-compare-content">
					<div class="form-group">
						<label><cf_get_lang dictionary_id="48799.Source"></label>
						<select id="datasources1">
						</select>
					</div>
					<div class="form-group">
						<label>	<cf_get_lang dictionary_id="57951.Hedef"></label>
						<select id="datasources2" multiple style="height:250px;">
						</select>
					</div>
					<div class="form-group">
						<input class="diff-btn" type = "button" onClick="compare();" value="<cf_get_lang dictionary_id="32516.Karşılaştır">">
					</div>
				</div>
			</div>
		</div>
	</div>
	<div class="col col-9 col-xs-12 padding-0">
		<div class = "row" id = "diffArea">
		</div>
	</div>
</div>


<script type = "text/javascript">

	function selectColumns(target_ds, object_name) {
		$("." + target_ds + '.' + object_name).prop('checked',$("." + target_ds + '.' + object_name).prop('checked'));

		return true;
	}

	function getDatasources() {
		$.ajax({
			url: 'Utility/schemaComparison.cfc',
			data: {method: 'getDatasources'},
			success: function(data) {
				$("#datasources1").empty();
				$("#datasources2").empty();

				if(data == -1) {
					alert('Invalid CF Password!');
					return false;
				} else {
					dsArray = $.parseJSON(data).DATA;

					$.each( dsArray, function( key, value ) {
						$("#datasources1").append('<option value = "' + value + '">' + value + '</option>');
						$("#datasources2").append('<option value = "' + value + '">' + value + '</option>');
					});
				}
			}
		});
	}

	function compare() {
		$('#diffArea').append("<p class='db-compare-info'><cf_get_lang dictionary_id='64470.İşleminiz gerçekleşiyor'>.<cf_get_lang dictionary_id='64471.Lütfen Bekleyiniz'>...</p>");
		$('.diff-btn').hide();
		if($("#datasources1").val() == null || $("#datasources2").val() == null) {
			alert('<cf_get_lang dictionary_id="64472.Kaynak ve hedef veri kaynaklarını seçin">!');
			return false;
		}
		ds2List = '';
		$.each( $("#datasources2").val(), function( key, value ) {
			ds2List = ds2List + ',' + value;
		});
		ds2List = ds2List.substring(1,ds2List.length);
		$.ajax({
			method : "post",
			url: 'Utility/schemaComparison.cfc',
			data: {method: 'schemaComparison',  source_ds: $("#datasources1").val(),  target_ds: ds2List, cfpass : $("#cfpass").val()},
			success: function(data) {
				var resObject = $.parseJSON(data);

				$("#diffArea").empty();
				$('.diff-btn').show();

				$.each(resObject, function(targetkey,target) {
					schemaDiv = $("<div />");
					schemaDiv.attr('class','col col-4 col-md-6 col-sm-12');
					schemaDiv.attr('id',targetkey);

					schemaPortbox = $("<div />");
					schemaPortbox.attr('class','portBox margin-bottom-15 border border-grey-silver');
					schemaPortbox.appendTo(schemaDiv);

					schemaPorthead = $("<div />");
					schemaPorthead.attr('class','portHead');
					schemaPorthead.append($("<span />").append(targetkey));
					schemaPorthead.appendTo(schemaPortbox);

					schemaPortbody = $("<div />");
					schemaPortbody.attr('style','display: block;');

					mainul = $("<ul />");
					mainul.attr('class','standartList db_tables');

					$.each(target, function(objectkey,object) {
						objectli = $("<li />");

						if(object.DIFFTYPE == 'missing_object') {
							objectli.attr('class','type_1');
						} else if(object.DIFFTYPE == 'different_object') {
							objectli.attr('class','type_2');
						}

						objectbox = $("<input />");
						objectbox.attr('type','checkbox');
						objectbox.attr('class',targetkey + ' ' + objectkey);
						objectbox.attr('value','1');
						objectbox.attr('onClick','selectColumns("' + targetkey + '","' + objectkey + '");');
						objectbox.attr('data-drop_index_sql',object.DROP_INDEXES_SQL);
						objectbox.attr('data-create_index_sql',object.CREATE_INDEXES_SQL);
						objectbox.attr('data-drop_index_sql_used',0);
						objectbox.attr('data-create_index_sql_used',0);

						if(object.DIFFTYPE == 'missing_object') {
							objectbox.attr('data-dif_sql',object.DIFFSQL);
						}

						objectbox.appendTo(objectli);

						objecta = $("<a />");
						objecta.attr('href','javascript://');
						objecta.attr('onClick',"$(this).next('ul').toggleClass('hide');");
						objecta.attr('title',object.DIFFDESCRIPTION);
						objecta.append(objectkey);
						objecta.appendTo(objectli);

						if(object.DIFFTYPE == 'different_object') {
							colul = $("<ul />");
							colul.attr('class','hide');

							$.each(object.COLUMNS, function(colkey,col) {
								colli = $("<li />");

								collabel = $("<label />");
								collabel.attr('title',col.DIFFDESCRIPTION);

								colinput = $("<input />");
								colinput.attr('type','checkbox');
								colinput.attr('class',targetkey + ' ' + objectkey + ' ' + colkey);
								colinput.attr('value','1');
								colinput.attr('data-dif_sql',col.DIFFSQL);

								colinput.appendTo(collabel);
								collabel.append(colkey);

								collabel.appendTo(colli);

								colli.appendTo(colul);
							});

							colul.appendTo(objectli);
						}

						objectli.appendTo(mainul);
					});
					mainul.appendTo(schemaPortbox);

					schemaPortbody.appendTo(schemaPortbox);

					buttonContainer = $('<div />');
					buttonContainer.attr('class',"db-compare-run");

					textareaContainer = $('<div />');
					textareaContainer.attr('class',"db-abs");

					closeButtonContainer = $('<i/>');
					closeButtonContainer.attr('class','db-abs-cl icon-minus');
					closeButtonContainer.click(function(){
						$(this).parent().stop().fadeOut();	
					})

					closeButtonContainer.appendTo(textareaContainer);

					sqlArea = $("<textarea />");
					sqlArea.attr({'class':targetkey});
					
					sqlArea.appendTo(textareaContainer);
					textareaContainer.appendTo(schemaPortbox);

					sqlbutton = $("<input />");
					sqlbutton.attr({'type':'button','onClick':'generateSQL("' + targetkey + '")', 'class':'generate-btn', 'value':'Generate SQL'});
					sqlbutton.click(function(){
						$(this).parent().parent().find('.db-abs').stop().fadeIn();	
					})
					sqlbutton.appendTo(buttonContainer);

					runButton = $("<input />");
					runButton.attr({'type':'button','onClick':'runSQL("' + targetkey +'");', 'class':'run-btn', 'value':'RUN at Target'});
					
					runButton.appendTo(buttonContainer);

					buttonContainer.appendTo(schemaDiv);

					schemaDiv.appendTo($("#diffArea"));
				});
			}
		});
	}

	function runSQL(targetDS) {
		$('.run-btn').attr("value","LOADING");
		sql2run = $("." + targetDS).val();
		datasource = targetDS;

		if(sql2run.length > 0) {
			$.ajax({
				url: 'Utility/schemaComparison.cfc',
				method: 'POST',
				data: {method: 'runSQL',  datasource: datasource,  query: sql2run},
				success: function(data) {
					var resObject = $.parseJSON(data);
					$('.run-btn').attr("value","RUN");
					alert(resObject.MESSAGE);
				}
			});
		} else {
			alert('Query is empty.');
		}
		return true;
	}

	function generateSQL(targetDS) {
		$('.' + targetDS).val('');

		dropIndexes = '';
		$("#" + targetDS + " :checkbox").each(function(){
			var $this = $(this);
			if($this.is(":checked")){
				var tableCheckbox = $this.closest('ul').closest('li').find(':input');
				if(tableCheckbox.data('drop_index_sql_used') == 0) {
					var dropIndexSQL = tableCheckbox.data('drop_index_sql');

					if(dropIndexSQL != undefined) {
						dropIndexes = dropIndexes + ' ' + dropIndexSQL;
					}

					tableCheckbox.data('drop_index_sql_used',1);
				}
			}
		});

		createIndexes = '';
		$("#" + targetDS + " :checkbox").each(function(){
			var $this = $(this);
			if($this.is(":checked")){
				var tableCheckbox = $this.closest('ul').closest('li').find(':input');
				if(tableCheckbox.data('create_index_sql_used') == 0) {
					var createIndexSQL = tableCheckbox.data('create_index_sql');

					if(createIndexSQL != undefined) {
						createIndexes = createIndexes + ' ' + createIndexSQL;
					}

					tableCheckbox.data('create_index_sql_used',1);
				}
			}
		});

		$("#" + targetDS + " :checkbox").each(function(){
			var $this = $(this);
			if($this.is(":checked")){
				var tableCheckbox = $this.closest('ul').closest('li').find(':input');
				var boxSQL = $this.data("dif_sql");

				if(boxSQL != undefined) {
					currentSQL = $('.' + targetDS).val();
					$('.' + targetDS).val(currentSQL + boxSQL + ';\n\n');
				}

				tableCheckbox.data('drop_index_sql_used',0);
				tableCheckbox.data('create_index_sql_used',0);
			}
		});

		$('.' + targetDS).val(dropIndexes + ' ' + $('.' + targetDS).val() + ' ' + createIndexes);
	}
</script>