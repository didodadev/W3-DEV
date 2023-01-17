<html>
  <head>
    <cfoutput>
      <!-- Required meta tags -->
      <meta charset="utf-8">
      <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
      <meta name="description" content="#PRIMARY_DATA.DETAIL#" >
      <meta name="keywords" content="#PRIMARY_DATA.META_KEYWORD#" >
      <title>LOGIN | #PRIMARY_DATA.TITLE#</title>
    </cfoutput>
    <link rel="stylesheet" href="/src/assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="/src/assets/css/login_2.css">
    <script src="/src/assets/js/jquery-3.4.1.slim.min.js" ></script>
    <script src="/src/assets/js/popper.min.js"></script>
    <script src="/src/assets/js/bootstrap.min.js"></script>
    <script src="/src/assets/js/vue.js"></script>
    <script src="/src/assets/js/axios.min.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-beta1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-giJF6kkoqNQ00vy+HMDP7azOuL0xtbfIcaT9wjKHr8RbDVddVHyTfAAsrekwKmP1" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    <link rel="manifest" href="/manifest.cfc?method=get">
    <link rel="icon" type="image/png" href="/src/includes/manifest/<cfoutput>#PRIMARY_DATA.FAVICON#</cfoutput>"/> 
  </head>
  <body class="body">
    <div class="container" id="protein_login">
      <div class="row m-auto">
        <div class="row justify-content-end">                    
          <div class="col-md-2 col-sm-2 " style=" height: 150px; margin-top:2%;">                        
            <p class="d-flex flex-row-reverse bd-highlight">
              <a v-show="false" class="btn" href="#" style="color: white; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;">>Workcube Hakkında</a>
            </p>
          </div>
        </div>
      </div>
      <div class="row">
        <div class="col-md-4">
          <img alt="Workcube Image" class="img-fluid login-image " src="/src/assets/img/w3.jpg" />
        </div>
        <div class="col-md-4" style="margin-top:2%">
          <form role="form" class="login-form" @submit="sendForm">
            <div class="form-group" v-if="portal != 'cp'">                        
              <label for="member_code">Kurumsal Üye Kodu</label>
              <div class="input-group">                        
                <input type="text" class="form-control" id="member_code" v-model="models[0].member_code" required />
                <div class="input-group-append">
                  <div class="input-group-text" style="background-color: white; border: none; border-top-right-radius: 10px; border-bottom-right-radius: 10px;">
                    <i class="fa fa-home"></i>
                  </div>
                </div>
              </div>
            </div>   
            <div class="form-group">
              <label for="username">Kullanıcı Adı</label>
              <div class="input-group">
                <input type="text" class="form-control" id="username" v-model="models[0].username" required />
                <div class="input-group-append ">
                  <div class="input-group-text" style="background-color: white; border: none; border-top-right-radius: 10px; border-bottom-right-radius: 10px;">
                    <i class="fa fa-user"></i>
                  </div>
                </div>
              </div>
            </div>
            <div class="form-group">                         
              <label for="member_password">Password</label>
                <div class="input-group">
                  <input type="password" class="form-control" id="exampleInputPassword1" v-model="models[0].member_password" required />
                  <div class="input-group-append">
                    <div class="input-group-text" style="background-color: white; border: none; border-top-right-radius: 10px; border-bottom-right-radius: 10px;">
                      <i class="fa fa-eye" @click="seePassword()"></i>
                    </div>
                  </div>
                </div>
              </div>                    
            <div class="form-group">
              <div class="form-check pl-0">
                <label class="form-check-label">
                  <small class="d-block text-danger" v-if="status_message">{{status_message}}</small>                        
                </label>
                <button type="submit" class="btn btn-lg btn-block" v-if="process == 0 || process == 200" :disabled="!send_status">GİRİŞ</button>
                <button type="submit" class="btn btnl-lg btn-info btn-block"  v-else-if="process == 201" :disabled="!send_status">Oturumu Kurtar</button>
                <button type="submit" class="btn btn-lg btn-warning btn-block"  v-else :disabled="!send_status">Tekrar Dene</button>
                <label for="forgotPassword"><a href="#" style="color: black; text-decoration: none;"  v-show="false">>Şifremi unuttum</a></label>
              </div>
            </div>                   
          </form>
        </div>            
      </div>
    </div>
  </body>
  <script>
    var proteinApp = new Vue({
      el : '#protein_login',
      data : {
        protein : '2020',
        models : [{
          member_code:'',
          username:'',
          member_password:'',
          force_login:0          
        }],
        send_status : true,
        status_message : '',
        process : 0,
        <cfif ACCESS_DATA.CONSUMER.STATUS>
            portal: 'ww',
        <cfelseif ACCESS_DATA.COMPANY.STATUS>
            portal: 'pp',
        <cfelseif ACCESS_DATA.CARIER.STATUS>
            portal: 'cp',
        </cfif>
        error: [],
      },
      methods : {
        sendForm : function(e){
          console.log('FN:LOGIN');
          this.send_status = false;
          axios.post( "/cfc/SYSTEM/LOGIN.cfc?method=GET_LOGIN_CONTROL", proteinApp.models[0])
          .then(response => {
                  console.log(response.data);
                  if(response.data.STATUS == true){
                      proteinApp.process = response.data.PROCESS;
                      switch(response.data.PROCESS) {
                        case 200:
                          // Başarılı
                          proteinApp.status_message = "Oturum Açıldı, Yönlendiriliyor";
                          setTimeout(function(){location.reload();} , 2000);
                          break;
                        case 201:
                          // Askıda, Kullanıcı Şuan İçeride
                          proteinApp.status_message = "Kullanıcı Şuan İçeride - CODE:201";
                          proteinApp.models[0].force_login = 1;
                          proteinApp.send_status = true;
                          break;
                        case 202:
                          // Kullanıcı Bilgileri Hatalı
                          proteinApp.status_message = "Kullanıcı Bilgileri Hatalı - CODE:202";
                          proteinApp.send_status = true;
                          break;
                        default:
                          // Başarısız istek
                          proteinApp.status_message = "Başarısız istek";
                          proteinApp.send_status = true;
                      }                    
                  }else{
                    switch(response.data.PROCESS) {
                        case 203:
                          // Yanıt alınamadı
                          proteinApp.status_message = "Yanıt alınamadı - CODE:203";
                          proteinApp.send_status = true;
                          break;
                        default:
                          // Başarısız istek
                          proteinApp.status_message = "Başarısız istek";
                          proteinApp.send_status = true;
                      }                  
                  }
                                        
          })
          .catch(e => {
              proteinApp.error.push({ecode: 1000, message:"Şuanda İşlem Yapılamıyor...."})
              this.send_status = true;
          })   
          e.preventDefault(); return false;
        
        },
        seePassword : function(e){
          var x = document.getElementById("exampleInputPassword1");
          if (x.type === "password") {
            x.type = "text";
          } else {
            x.type = "password";
          }
        }
      }
    })
  </script>
</html>





