# jenkins-up-docker-dotnet
Bu uygulamayı Jenkins'i anlamak, test etmek ve anlamayı kolaylaştırmak amacıyla yazdım. \
Jenkins servisi Dockerfile ve compose kullanılarak Blue Ocean ve Docker Pipeline pluginleri ile birlikte docker üzerinden dağıtılır. Ayrıca masaüstünüzdeki Docker'a Jenkins, linux containerden root yetkisiyle erişim sağlar. \
https://www.jenkins.io/doc/book/installing/docker/ Dökümanındaki adımları yaparsanız Docker içerisine bağımsız bir Docker kurar ve Jenkins onunla iletişime geçer. Ben bunu istemediğim için dökümana sağdık kalmayacağım. 

Kurulum Gereksinimleri:
 - Docker Desktop (docker ve docker compose)
 - Git Bash
 - DotnetSDK 5.0
 - Bazı kurulumlar için internet bağlantısı
 
Kurulumdan önce jobları test edebilmemiz için github'ta ve docker hub'ta bir repository oluşturmanız gerekiyor. \
Otomatik Kurulum:
<pre>
 - 'all-in-one-setup.bat' dosyasını çalıştırın. Sizden github repository adresi ve docker hub repository ismi isteyecektir. Burada Github adresini, oluşturacağı bir örnek mvc projesini hesabınıza push etmek için kullanacaktır. Docker hub repository ismi ise oluşturulan projenin docker-compose.yml dosyası için gereklidir.
    örneğin => github: 'https://github.com/gokanil/test.git' ve dockerhub: 'gokanil/test'.
 - Kurulum sırasında bir sh penceresi açılacaktır. 'done' yazısını gördüğünüzde enter tuşuna basarak kuruluma devam edin.
 - Yine kurulum sırasında 'ngrok' isminde yeni bir konsol penceresi daha açılacaktır. Bu localinizdeki bir jenkins sunucusunu github webhook ile iletişim kurmasını sağlıyacak.
 - Kurulum sizi webhook oluşturmanız için bir web sitesine yönlendirecektir. Eğer yönlendirmediyse: 'https://github.com/[USER]/test/settings/hooks'. [USER] yazan yere kullanıcı
   adınızı yazmalısınız. Ngrok konsol içerisinden size tanımlanan web adresini kopyalayın: 'https://a970-85-104-8-130.ngrok.io'.
   Bu adresi github webhook kısmındaki Payload URL kısmına yapıştırın ve yanına /github-webhook/ ekleyin. : https://a970-85-104-8-130.ngrok.io/github-webhook/
   Content type'i json olarak seçin ve addwebhook ile işi bitirelim. ngrok konsol penceresinde POST /github-webhook/ yazısını görmelisiniz. Eğer bu yazının sağ tarafı boş ise
   webhook bağlantısı başarılı olmuş demektir.<details><summary>Github WebHook ekleme:</summary><img src="/images/git2.png" /></details>
 - Jenkins'i kullanmak için http://localhost:8080/ adresine gidebiliriz. Bizden bir Administrator password istiyecektir. 'jenkins-get-first-key.bat' bize bu keyi getirecektir.
   Kopyalayın ve yapıştırın devam edelim.
 - Konsol kurulum penceresini artık kapatabiliriz. Jenkins adresinden kuruluma devam edelim.
 - Karşınızda oluşturduğum bazı jobları görmeniz gerekiyor. Öncelikle test-docker-version jobunu çalıştıralım. Açın ve şimdi yapılandıra basın. Eğer hata yok ise Kurulum tamamdır.    Diğer joblarıda test etmeye başlayabiliriz.
</pre>

<details>
<summary>Manuel Kurulum ve Dosyalar:</summary>
 <pre>
 - Uygulama konumunda konsole penceresine 'docker-compose up -d --build' komunutu yazarak jenkins uygulamasını docker üzerinde çalıştıracaktır. <br>
 - Jenkins çalışma sırasında yml dosyasınki './jenkins_data:/var/jenkins_home' sayesinde uygulama konumuna 'jenkins_data' isminde bir klasör oluştur. eğer bu klasörü oluşturmasaydık, Jenkins servisi her sıfırlandığında kurulum ve ayarlarınızı baştan yapmanız gerekirdi.<br>
 - Jenkins kurulum sırasında jobs klasörünü 'jenkins_data' klasörüne kopyalamanız lazım. Çünkü job klasörü içerisinde önceden hazırladığım örnekler vardır.<br>
 - ASPNETCORE-Sample-For-Jenkins klasörünün içerisindeki 'create-mvc-sample.bat' dosyası ile veya 'dotnet new mvc --language C# --output sample-mvc\sample-mvc --name sample-mvc -f net5.0' komutu ile sample-mvc isminde bir mvc projesi oluşturulur. Jenkins içerisindeki testleri bu proje ile yapacağız. sample-mvc projesi oluştukdan sonra files klasöründeki bütün dosyaları docker ve jenkins testlerini yapabilmemiz için sample-mvc klasörüne kopyalamalısınız.<br>
 - sample-mvc/.gitignore https://raw.githubusercontent.com/github/gitignore/master/VisualStudio.gitignore adresindeki dosyayıda sample-mvc klasörüne indirin.<br>
 - 'docker-compose.yml' isimli dosyadaki 'image: <image>' satırındaki <image> kısmına dockerhub reponozun ismini yazmalısınız. 'image: gokanil/test'<br>
 - 'github-push-sample.sh' isimli dosya ile sample-mvc uygulamasını github hesabınıza atabilirsiniz. Veya https://docs.github.com/en/github/importing-your-projects-to-github/importing-source-code-to-github/adding-an-existing-project-to-github-using-the-command-line buradaki döküman ile yapabilirsiniz.<br>
 - webhook için https://ngrok.com/download adresinden ngrok uygulamasını indirmeniz gerekiyor.
 - ngrok.zip dosyasını indirdikten sonra çıkarıp exe uygulamasını açın. 'ngrok http 8080' komunutu girin. Jenkins uygulamasını 8080 portunda kaldırdığımız için bu portu kullanıyoruz. <br>
 - https://github.com/[USER]/test/settings/hooks adresine giderek bir webhook oluşturmanız gerekiyor.<details><summary>Github WebHook ekleme:</summary><img src="/images/git2.png" /></details>
 - Jenkins'i kullanmak için http://localhost:8080/ adresine gidebiliriz. Bizden bir Administrator password istiyecektir. 'jenkins-get-first-key.bat' bize bu keyi getirecektir.
   Kopyalayın ve yapıştırın devam edelim.<br>
 - Karşınızda oluşturduğum bazı jobları görmeniz gerekiyor. Öncelikle test-docker-version jobunu çalıştıralım. Açın ve şimdi yapılandıra basın. Eğer hata yok ise Kurulum tamamdır.    Diğer joblarıda test etmeye başlayabiliriz.
 </pre>
</details>

