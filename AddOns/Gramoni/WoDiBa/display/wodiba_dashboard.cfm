<script src="AddOns/Gramoni/WoDiBa/assets/js/highcharts.js"></script>
<script src="AddOns/Gramoni/WoDiBa/assets/js/highcharts-3d.js"></script>
<script src="AddOns/Gramoni/WoDiBa/assets/js/exporting.js"></script>
<script src="AddOns/Gramoni/WoDiBa/assets/js/export-data.js"></script>
<link rel="stylesheet" href="AddOns/Gramoni/WoDiBa/assets/css/font-awesome.min.css">
<style>
	.progress-bar{box-shadow:none!important}
	.dashboard-stat2{float:left;width:100%;padding:10px 15px;margin:0 0 10px 0;background-color:#f9f9f9;border:1px solid #eaeaea;border-top:4px solid #eaeaea;letter-spacing:1px;}
	.dashboard-stat2 .progress-info .status{float:left;width:100%;margin-top:10px;text-transform:initial!important;}
	.dashboard-stat2 .display{margin:0;}
	.dashboard-stat2 .display .date{float:right;font-size:14px;line-height:25px;}
	.number h4{font-size: 12px;font-weight: bold;background: #2ab4c0;padding: 5px 10px;color: #fff;border-radius: 4px;}
	.number h4 i{font-size:15px;color:#fff;margin-right:5px;}
	.status a{display:inline-block;padding:5px 10px;border:1px dashed #2ab4c0;color:#555;border-radius:4px;transition:.4s;}
	.status a:hover{color:#fff;background-color:#2ab4c0;transition:.4s;}
	.status a:hover i{color:#fff;transition:.4s;}
	.status a i{text-align:center;margin-right:5px;color:#2ab4c0;font-size:12px;}
	.dashboard-stat2-content{float:left;width:100%;padding:10px;}
	.content-item{float:left;width:100%;padding:5px 0;}
	.content-item p{margin:0;}
	.content-item p sub{margin-left:5px;}
	.circleContent { width:25% }
	@media screen and (max-width: 1200px) {
		.circleContent { width:33%!important; }
	}
	@media screen and (max-width: 992px) {
		.circleContent { width:33% !important; }
	}
	@media screen and (max-width: 768px){
		.circleContent { width:33%!important; }
	}
	@media screen and (max-width: 548px){
		.circleContent { width:50%!important; }
	}
	@media screen and (max-width: 319px){
		.circleContent { width:100%!important; }
	}

	.notification-count{
		background-color: rgba(3, 109, 187, 0.9);
		min-width: 14px;
		padding: 5px;
		margin-left: 10px;
		border-radius: 55px;
		position: absolute;	
		font-size: 12px;
		box-shadow: 1px 1px 1px rgba(0, 0, 0, 0.7);
		vertical-align: middle;
		color: #fff;
	}
  .flex-container {
  	display: flex;
  	flex-wrap: nowrap;
	}
</style>
<cfscript>
  	include "../cfc/Functions.cfc";
	money_type	= GetBankMoneyTypes();
</cfscript>
<script type="text/javascript">
  function formatMoney(n) {
      return parseFloat(n).toFixed(2).replace(/(\d)(?=(\d{3})+\.)/g, '$1.').replace(/\.(\d+)$/,',$1');
  }

  function graps(){
    $.ajax({ url :'AddOns/Gramoni/WoDiBa/cfc/Functions.cfc?method=GetBankMoney',
                async:false,
                datatype:'json',
                success:function(res){
                  data = res.replace('//""','');
                  data = $.parseJSON(data);
				  <cfoutput query="money_type">
					#DOVIZTURU# = 0;
				  </cfoutput>
                  $.each(data, function (key, entry) {
					<cfoutput query="money_type">
					if(entry.DOVIZTURU=="#DOVIZTURU#"){#DOVIZTURU#=parseFloat(#DOVIZTURU#)+entry.BAKIYE;}
					</cfoutput>
				  });
				  <cfoutput query="money_type">
                  if(#DOVIZTURU#==0){document.getElementById("#DOVIZTURU#_val").hidden=true;}else{document.getElementById("#DOVIZTURU#_val").hidden=false;}
                  document.getElementById("#DOVIZTURU#").innerHTML=formatMoney(#DOVIZTURU#);
				</cfoutput>

                  accounts = [];
                  $.each(data, function (key, entry) {
                          accounts.push({y: entry.BAKIYE, name: entry.ACCOUNT_NAME});
                        })
                        Highcharts.chart('container', {
                          chart: {
                              type: 'pie',
                              options3d: {
                              enabled: true,
                              alpha: 45,
                              beta: 0
                              }
                          },
                          title: {
                              text: 'Banka Hesapları'
                          },
                          tooltip: {
                              pointFormat:'{point.y}: <b>{point.percentage:.1f}%</b>'
                          },
                          plotOptions: {
                              pie: {
                              allowPointSelect: true,
                              cursor: 'pointer',
                              depth: 35,
                              dataLabels: {
                                  enabled: true,
                                  format: '{point.name}'
                              }
                              }
                          },
                          series: [{
                              type: 'pie',
                              name: accounts,
                              data: accounts
                          }]

                      });
              }
          });
          $.ajax({ url :'AddOns/Gramoni/WoDiBa/cfc/Functions.cfc?method=GetInOut&InOut=IN',
                async:false,
                datatype:'json',
                success:function(res){
                  data = res.replace('//""','');
                  data = $.parseJSON(data);

                  girisler=[];
                  $.each(data, function (key, entry) {
                    girisler[entry.TARIH-1]=parseInt(entry.MIKTAR);
                  }) 
                  for(i=0;i<12;i++)
                        {
                          if(girisler[i]==null)
                          {
                            girisler[i]=0;
                          }
                        }
                }
            });
            $.ajax({ url :'AddOns/Gramoni/WoDiBa/cfc/Functions.cfc?method=GetInOut&InOut=OUT',
                async:false,
                datatype:'json',
                success:function(res){
                  data = res.replace('//""','');
                  data = $.parseJSON(data);

                  cikisler = [];
                  $.each(data, function (key, entry) {
                          var miktar=''+ entry.MIKTAR +'';
                          cikisler[entry.TARIH-1]=parseInt(miktar.replace('-',''));
                        })
                        for(i=0;i<12;i++)
                        {
                          if(cikisler[i]==null)
                          {
                            cikisler[i]=0;
                          }
                        }
                }
            });
            Highcharts.chart('container1', {
                  chart: {
                      type: 'line'
                  },
                  title: {
                      text: 'Aylara Göre Giriş Çıkış'
                  },
                  xAxis: {
                      categories: ['Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran', 'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık']
                  },
                  yAxis: {
                      title: {
                      text: ''
                      }
                  },
                  plotOptions: {
                      line: {
                      dataLabels: {
                          enabled: true
                      },
                      enableMouseTracking: false
                      }
                  },
                  series: [
                    {name: 'GİRİŞ',data: girisler},
                    {name: 'ÇIKIŞ',data: cikisler}
                  ]
              });
              $("#tableBody").empty();
              $.ajax({ url :'AddOns/Gramoni/WoDiBa/cfc/Functions.cfc?method=GetWodibaBankActions',
                async:false,
                datatype:'json',
                success:function(res){
                  data = res.replace('//""','');
                  data = $.parseJSON(data);
                  $.each(data, function (key, entry) {
                    if(entry.ISLEMKODU.length==0)
                    {
                      entry.ISLEMKODU = 0;
					}
					in_out = entry.IN_OUT;

					if(in_out=="IN") {
						$("#tableBody").append(
							"<tr>"+
								"<td style='width:15%;text-align:center;border: 2px solid green;'>"+
								"<div class='input-group'>"+
								"<i class='fa fa-arrow-down' style='font-size:20px;color:green;'></i>"+
								"</div>"+
								"</td>"+
								"<td style='width:85%;text-align:center;border: 2px solid green;font-size:15px' nowrap>"+
								"<strong>"+entry.PROCESS_TYPE+"</strong>"+
								"</td>"+
								"<td style='width:85%;text-align:right;border: 2px solid green;font-size:15px' nowrap>"+
								formatMoney(entry.MIKTAR)+" "+entry.DOVIZTURU+
								"</td>"+
							"</tr>"
						);
					}
					else {
						$("#tableBody").append(
						"<tr>"+
							"<td style='width:15%;text-align:center;border: 2px solid red;'>"+
							"<div class='input-group'>"+
							"<i class='fa fa-arrow-up ' style='font-size:20px;color:red;'></i>"+
							"</div>"+
							"</td>"+
							"<td style='width:85%;text-align:center;border: 2px solid red;font-size:15px' nowrap>"+
							"<strong>"+entry.PROCESS_TYPE+"</strong>"+
							"</td>"+
							"<td style='width:85%;text-align:right;border: 2px solid red;font-size:15px' nowrap>"+
							formatMoney(entry.MIKTAR)+" "+entry.DOVIZTURU+
							"</td>"+
						"</tr>"
						);
					}
                  })
                }
            });
  }

  $(window).load(function(){
        graps();
      });
</script>

    <div class="col col-12">
    <cf_box title="#getLang('bank',191)# #getLang('hr',646)#" closable="0" collapsable="0" collapsed="0">

	<div class="flex-container">
	<cfoutput query="money_type">
	  <div id="#DOVIZTURU#_val" class="col col-3 col-md-3 col-sm-6 col-xs-12" >
        <div class="dashboard-stat2" style="background:##FDF2E9;border-radius:15px">
          <div class="dashboard-stat2-content">
            <div class="content-item">
              <div class="col col-6 col-md-6 col-sm-6 col-xs-6" style="color:gray;font-size:15px;margin-left:-20px">
                <b>#DOVIZTURU#</b></br>
                <b id="#DOVIZTURU#" style="font-size:30px;color:black"></b>
              </div>
            </div>
          </div>
        </div>
      </div>
	</cfoutput>
	</div>
      
      <!---<div class="col col-12 col-md-3 col-sm-12 col-xs-12" style="width:100%;height:15px;text-align:right;" >
        <span class="input-group-btn">
          <button class="btn btn-default" type="button" style="margin-right:10px;background:#E8F8F5 ">Bugün</button>&nbsp;&nbsp;
          <button class="btn btn-default" type="button" style="margin-right:10px;background:#F4ECF7 ">Bu Ay</button>&nbsp;&nbsp;
          <button class="btn btn-default" type="button" style="margin-right:10px;background:#FDEDEC">Bu Yıl</button>
        </span>
      </div>
      <div class="col col-12 col-md-3 col-sm-12 col-xs-12" style="width:100%;height:15px;text-align:right;margin-right:10px" >
        Yenileme :
        <select id="ref" onchange="Refresh_interval(this.value)">
          <option value="3000" selected>3 sn</option>
          <option value="5000">5 sn</option>
          <option value="10000">10 sn</option>
          <option value="25000">25 sn</option>
          <option value="60000">60 sn</option>
        </select>
      </div>
      <br/>--->
       <div style="margin-top:50px">
        <div class="col col-md-3 col-sm-12 col-xs-12" style="width:480px">
            <div id="container" style="height: 500px"></div>
        </div>
        <div class="col col-4 col-md-3 col-sm-12 col-xs-12">
            <div id="container1" style="min-width: 300px; height: 500px; margin: 0 auto"></div>
        </div>
        <div class="col col-3 col-sm-12 col-xs-12">
          <table width="95%" style="margin-left:15px">
            <thead frame="box">
              <tr>
                <th colspan="3" style="text-align:center;width:100%;font-size:18px;color:#333333;">SON İŞLEMLER</th>
              </tr>
            </thead>
            <tbody id="tableBody"></tbody>
          </table>
        </div>
      </div>
    </cf_box>
</div>

<script type="text/javascript">
  interval_value=10000;
  function Refresh_interval(x) {
    var interval_value=x;
    console.log(interval_value);
  }
  window.setInterval( graps,interval_value);
</script>