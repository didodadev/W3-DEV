<html>
  <head>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
    <cfoutput> 
        <cfset PRIMARY_DATA = #deserializeJSON(GET_SITE.PRIMARY_DATA)#>
        <meta name="description" content="#PRIMARY_DATA.DETAIL#" >
        <meta name="keywords" content="#PRIMARY_DATA.META_KEYWORD#" >
        <title>#PRIMARY_DATA.TITLE#</title>
    </cfoutput>
    <style>
        body {
            background: url(/src/assets/img/welcome.jpg) no-repeat #0090d7;
            background-position: center;boot
        }
        .logo {               
            position: absolute;
            bottom: 65px;
            right: 30px;
        }

        small {
            font-size: 12pt;
            text-align: right;
            display: block;
            color: #ffffff;
            line-height: 0;
        }

        .input-group.view-login {
            position: absolute;
            bottom: 22px;
            right: 37px;
            width: 287px !important;
        }

        #protein_maintenance {
            position: absolute;
            bottom: 22px;
            right: 10px;
            width: 350px !important;
            height: 166px;
            background: #0090d7;
            padding: 26px;
        }

        label.status-message {
            position: absolute;
            bottom: 12px;
        }
    </style>
    <script  type="text/javascript" src="/src/assets/js/axios.min.js"></script>
    <script  type="text/javascript" src="/src/assets/js/vue.js"></script> 
  </head>
  <body>    
    <div id="protein_maintenance">
        <img src="/src/assets/img/protein-white.png" class="logo">
        <form role="form" class="login-form" @submit="sendForm">
            <div class="input-group view-login">
                <input type="password" class="form-control" placeholder="Maintenance Password..." v-model="models[0].maintenance_password">
                <span class="input-group-text" @click="sendForm">
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-lock-fill" viewBox="0 0 16 16">
                    <path d="M8 1a2 2 0 0 1 2 2v4H6V3a2 2 0 0 1 2-2zm3 6V3a3 3 0 0 0-6 0v4a2 2 0 0 0-2 2v5a2 2 0 0 0 2 2h6a2 2 0 0 0 2-2V9a2 2 0 0 0-2-2z"></path>
                </svg>
                </span>
            </div>
        </form>
        <label class="form-check-label status-message" >
            <small class="d-block text-danger" v-if="status_message">{{status_message}}</small>                        
        </label>
    </div>
    <!-- Optional JavaScript -->
    <!-- jQuery first, then Popper.js, then Bootstrap JS -->
    <script src="https://code.jquery.com/jquery-3.4.1.slim.min.js" integrity="sha384-J6qa4849blE2+poT4WnyKhv5vZF5SrPo0iEjwBvKU7imGFAV0wwj1yYfoRSJoZ+n" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js" integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6" crossorigin="anonymous"></script>
    <script>
        var proteinApp = new Vue({
          el : '#protein_maintenance',
          data : {
            protein : '2020',
            models : [{
                maintenance_password:''         
            }],           
            status_message : '',           
            error: [],
          },
          methods : {
            sendForm : function(e){
            e.preventDefault(); 
              proteinApp.status_message = 'Gönderiliyor...',
              axios.post( "/cfc/SYSTEM/LOGIN.cfc?method=maintenance_view", proteinApp.models[0])
              .then(response => {
                    console.log(response.data);
                    if(response.data.STATUS == true){
                        proteinApp.process = response.data.PROCESS;
                        switch(response.data.PROCESS) {
                        case 200:
                            // Başarılı
                            proteinApp.status_message = "Yönlendiriliyor";
                            setTimeout(function(){location.reload();} , 2000);
                            break;
                        case 202:
                            // Kullanıcı Bilgileri Hatalı
                            proteinApp.status_message = "Yanlış Parola";
                            break;
                        default:
                            // Başarısız istek
                            proteinApp.status_message = "Başarısız istek";
                        }                    
                    }else{
                    switch(response.data.PROCESS) {
                        case 203:
                            // Yanıt alınamadı
                            proteinApp.status_message = "Yanıt alınamadı - CODE:203";
                            break;
                        default:
                            // Başarısız istek
                            proteinApp.status_message = "Başarısız istek";
                            proteinApp.send_status = true;
                        }                  
                    }                                            
              })
              .catch(e => {
                    proteinApp.status_message = 'Şuanda İşlem Yapılamıyor....',
                    proteinApp.error.push({ecode: 1000, message:"Şuanda İşlem Yapılamıyor...."})
              })
              e.preventDefault(); return false;
            }
          }
        })
      </script>
    </body>
</html>