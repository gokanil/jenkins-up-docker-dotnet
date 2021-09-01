# jenkins-up-docker-dotnet
Bu uygulamayı Jenkins'i anlamak, test etmek ve anlamayı kolaylaştırmak amacıyla yazdım. \
Bu uygulama Jenkins uygulamasını docker üzerinden dağıtır. Ayrıca masaüstünüzdeki Docker'a jenkins linux containerden root yetkisiyle erişim sağlar. \
https://www.jenkins.io/doc/book/installing/docker/ Bu dökümandaki adımları yaparsanız Docker içerisine bağımsız bir Docker kurar ve Jenkins onunla iletişime geçer. Ben bunu istemediğim için dökümana sağdık kalmayacağım. 

Kurulum Gereksinimleri:
 - Docker Desktop (docker ve docker compose)
 - Git Bash
 - DotnetSDK 5.0
 - Bazı kurulumlar için internet bağlantısı
 
Kurulumdan önce jobları rahat test edebilmemiz için github'ta ve docker hub'ta bir public repository oluşturmanız gerekiyor. \
Kurulum:
 - 'all-in-one-setup.bat' dosyasını çalıştırın. Sizden github repository adresi ve docker hub repository ismi isteyecektir.(Girdilerden sonra örnek bir mvc projesi oluşturulacak ve bunu github hesabınıza yükleyecektir. Docker hub repository ismi ise docker-compose.yml dosyası için gereklidir.)
    örneğin => github: 'https://github.com/gokanil/test.git' ve dockerhub: 'gokanil/test'.
 - Kurulum sırasında bir sh penceresi açılacaktır. 'done' yazısını gördüğünüzde enter tuşuna basarak kuruluma devam edin.
 - Yine kurulum sırasında 'ngrok' isminde yeni bir konsol penceresi daha açılacaktır. Bu localinizdeki bir jenkins sunucusunu github webhook ile iletişim kurmasını sağlıyacak.
 - Kurulum sizi webhook oluşturmanız için bir web sitesine yönlendirecektir. Eğer yönlendirmediyse: 'https://github.com/[USER]/test/settings/hooks'. [USER] yazan yere kullanıcı
   adınızı yazmalısınız. Ngrok konsol içerisinden size tanımlanan web adresini kopyalayın: 'https://a970-85-104-8-130.ngrok.io'.
   Bu adresi github webhook kısmındaki Payload URL kısmına yapıştırın ve yanına /github-webhook/ ekleyin. : https://a970-85-104-8-130.ngrok.io/github-webhook/
   Content type'i json olarak seçin ve addwebhook ile işi bitirelim. ngrok konsol penceresinde POST /github-webhook/ yazısını görmelisiniz. Eğer bu yazının sağ tarafı boş ise
   webhook bağlantısı başarılı olmuş demektir.
   <details>
   <summary>Github WebHook ekleme:</summary>
   <img src="/images/git2.png" />
   </details>
 - Jenkins'i kullanmak için http://localhost:8080/ adresine gidebiliriz. Bizden bir Administrator password istiyecektir. 'jenkins-get-first-key.bat' bize bu keyi getirecektir.
   Kopyalayın ve yapıştırın devam edelim.
 - Konsol kurulum penceresini artık kapatabiliriz. Jenkins adresinden kuruluma devam edelim.
 - Karşınızda oluşturduğum bazı jobları görmeniz gerekiyor. Öncelikle test-docker-version jobunu çalıştıralım. Açın ve şimdi yapılandıra basın. Eğer hata yok ise Kurulum tamamdır.    Diğer joblarıda test etmeye başlayabiliriz.
 

