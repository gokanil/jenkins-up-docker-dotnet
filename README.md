# jenkins-up-docker-dotnet
Bu uygulamayı Jenkins'i anlamak, test etmek ve anlamayı kolaylaştırmak amacıyla yazdım. \
Jenkins servisi Dockerfile ve compose kullanılarak Blue Ocean ve Docker Pipeline pluginleri ile birlikte docker üzerinden dağıtılır. Ayrıca masaüstünüzdeki Docker'a Jenkins, linux containerden root yetkisiyle erişim sağlar. \
https://www.jenkins.io/doc/book/installing/docker/ Dökümanındaki adımları yaparsanız Docker içerisine bağımsız bir Docker kurar ve Jenkins onunla iletişime geçer. Ben bunu istemediğim için dökümana sağdık kalmayacağım. 

Kurulum Gereksinimleri:
 - Docker Desktop (docker ve docker compose)
 - Git Bash
 - DotnetSDK 5.0
 - Bazı kurulumlar için internet bağlantısı
 
Kurulumdan önce jobları test edebilmeniz için github'ta ve docker hub'ta bir repository oluşturmanız gerekiyor. Repo oluştururken isim ve visibility ayarından başka bir şey değiştirmenize gerek yoktur. Eğer github repositoryi private yaparsanız, jenkins üzerinden erişmek için access token oluşturmanız gerekiyor. https://github.com/settings/tokens 

Neden kurulum tamamen otomatik değil?
 - Çünkü bazı adımların kurulumdan sonra incelenmesi yerine bizzat kurulum sırasında yapılmasını daha öğretici olacağını düşünüyorum.

Otomatik Kurulum:
<pre>
 - 'all-in-one-setup.bat' dosyasını çalıştırın. Sizden github repository adresi ve docker hub repository ismi isteyecektir. Girdiğiniz Github adresini, kurulumun daha sonra oluşturacağı bir örnek mvc projesini, github hesabınıza yüklemek için kullanacaktır. Docker hub repository ismi ise oluşturulan projenin docker-compose.yml dosyası için gereklidir.
    örneğin => github: 'https://github.com/gokanil/test.git' ve dockerhub: 'gokanil/test'.
 - Kurulum sırasında bir sh penceresi açılacaktır. 'done' yazısını gördüğünüzde enter tuşuna basarak kuruluma devam edin.
 - Yine kurulum sırasında 'ngrok' isminde yeni bir konsol penceresi daha açılacaktır.(ngrok uygulamasını bulamazsa indirme işlemi yapacaktır.) Bu localinizdeki bir jenkins sunucusunu github webhook ile iletişim kurmasını sağlayacak.
 - Kurulum sizi webhook oluşturmanız için bir web sitesine yönlendirecektir. Eğer yönlendirmediyse: 'https://github.com/[USER]/test/settings/hooks'. [USER] yazan yere kullanıcı
   adınızı yazmalısınız. Ngrok konsol içerisinden size tanımlanan web adresini kopyalayın: 'https://a970-85-104-8-130.ngrok.io'.
   Bu adresi github webhook kısmındaki Payload URL kısmına yapıştırın ve yanına /github-webhook/ ekleyin. : https://a970-85-104-8-130.ngrok.io/github-webhook/
   Content type'i json olarak seçin ve addwebhook ile işi bitirelim. ngrok konsol penceresinde POST /github-webhook/ yazısını görmelisiniz. Eğer bu yazının sağ tarafı boş ise
   webhook bağlantısı başarılı olmuş demektir.<details><summary>Github WebHook ekleme:</summary><img src="/images/git2.png" /></details>
 - Jenkins'i kullanmak için http://localhost:8080/ adresine gidebiliriz.(loop olursa, jenkins kurulumu devam ediyor demektir.) Bizden bir Administrator password istiyecektir. 'jenkins-get-first-key.bat' bize bu keyi getirecektir.
   Kopyalayın ve yapıştırın devam edelim.
 - Konsol kurulum penceresini artık kapatabiliriz. Jenkins adresinden kuruluma devam edelim.
 - Karşınızda oluşturduğum bazı jobları görmeniz gerekiyor. Öncelikle test-docker-version jobunu çalıştıralım. Açın ve şimdi yapılandıra basın. (Eğer hata yok ise Kurulum başarılıdır.
 - Bazı jobları test edebilmeniz için Jenkins'e github ve dockerhub yetkisi vermeniz gerekiyor.(Eğer github repositorinizi public olarak açtıysanız, github yetkisi vermek zorunda değilsiniz.)
 Github yetkisi için öncelikle token oluşturmanız gerekiyor. Token oluşturmak için 'https://github.com/ > settings > Developer settings > Personal access tokens > Generate new token' yolundan veya https://github.com/settings/tokens/new adresinden direk olarak token oluşturma sayfasına gidebilirsiniz. 
 Burada bir not girerek ve repo kutusunu işaretleyerek token oluşturun. Oluşturulan bu tokeni sadece 1 kez görebilirsiniz. Sayfa kapatma gibi durumlarda token yenilemeniz gerekir.
 Jenkinsde yetki vermek için 'Jenkins'i Yönet > Manage Credentials > global > adding some credentials' yolunu izleyerek veya http://localhost:8080/credentials/store/system/domain/_/newCredentials adresinden direkt olarak credential ekleme sayfasına gidebilirsiniz. 
 Username yazan kısım Github kullanıcı adınız ve şifre yazan kısım ise biraz önce oluşturduğunuz tokendir. ID kısmı sadece bir isimdir. Fakat joblarda kullandığım ismi yazmanız gerekiyor 'githubCredential'. 
 Kaydedin ve dockerhub için tekrar credential oluşturmanız gerekiyor. Kullanıcı adı ve şifreniz dockerhub ile aynıdır. ID kısmına ise 'dockerhubCredential' yazmalısınız.
 - Artık diğer jobları test edebilirsiniz.
</pre>

<details>
<summary>Manuel Kurulum ve Dosyalar:</summary>
 <pre>
 - Uygulama konumundaki konsol penceresine 'docker-compose up -d --build' komunutu yazarak jenkins uygulamasını docker üzerinde çalıştırabilirsiniz. <br>
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

Hook Trigger Test
Hook trigger nedir?
 - Bir değişiklik durumunda belirtilen adresi bilgilendirme işlemidir.
 
Github Hook Trigger Kullanımı:
 - Ngrok uygulamasının çalışıyor olması gerekiyor. Eğer kapalı ise 'ASPNETCORE-Sample-For-Jenkins > bind-ngrok.bat' dosyasını çalıştırın. 
 - Açılan konsol penceresinde Forwarding kısmındaki https ile başlayan adresi kopyalayın. https://github.com/gokanil/[USER]/settings/hooks/new ([USER] yazan kısıma kullanıcı adınızı yazmalısınız) adresindeki payload url kısmına yapıştırın ve yanına '/github-webhook/' yazın. Ayrıca content type kısmını json seçmelisiniz.
 - Örnek olarak 4-github-dotnet-pipeline isimli jobu seçtim. jobu çalıştırın.
 - 4-github-dotnet-pipeline isimli jobun konfigürasyonunda 'GitHub hook trigger for GITScm polling' seçeneğini işaretleyin ve kaydedin.
 - http://localhost:5000/ adresine giderek uygulamanın mevcut halini görebilirsiniz.
 - Hatasız bir şekilde çalıştıysa 'sample-mvc > sample-mvc > Views > Home > Index.cshtml' dosyasını açın ve en alt satırına &lt;p&gt;github webhook trigger test&lt;/p&gt; ekleyin ve kaydedin.
 - Yaptığınız değişikliği github hesabınıza ekleyin.
 - 4-github-dotnet-pipeline job sayfasında adımların tekrar başladığını göreceksiniz. Başarılı olmasını bekleyin.
 - Şimdi http://localhost:5000/ adresine tekrar gidin ve yaptığınız değişikliği görmeniz gerekiyor.

Test Maili Gönderme:
 - 'Jenkins'i Yönet > Sistem Konfigürasyonunu Değiştir' yolundaki E-posta Bilgilendirmesi kısmındaki gelişmişe tıklayın.
 - örnek olarak gmail kullanacağım. SMTP sunucusu: smtp.gmail.com
 - 'Use SMTP Authentication' kutusunu işaretleyin.
 - Kullanıcı adı: x@gmail.com
 - şifre: ******
 - 'SSL kullan' kutusunu işaretleyin.
 - SMTP Portu: 465
 - Reply-To Address: x@gmail.com
 - atarak konfigürasyonu test et kutusunu işaretleyin
 - Test e-mail recipient: y@gmail.com
 - Bunları yaptıktan sonra Test configuration tuşuna basın ve başarılı ise mail adresinizi kontrol edin.

KAYNAKLAR \
https://www.jenkins.io/doc/book/installing/docker/ \
https://youtu.be/PZjLl4QgBJ0 \
https://newbedev.com/adding-net-core-to-docker-container-with-jenkins \
https://jhooq.com/requested-access-to-resource-is-denied/ \
https://faun.pub/docker-build-push-with-declarative-pipeline-in-jenkins-2f12c2e43807 \
https://code-maze.com/ci-jenkins-docker/ \
https://docs.docker.com/compose/install/ \
https://www.mshowto.org/docker-containera-rdp-ile-nasil-baglanabiliriz-bolum-1.html \
https://mehmetcantas.medium.com/net-core-3-0-projelerinde-docker-jenkins-ve-github-ile-continuous-deployment-s%C3%BCreci-part-1-afc62a09868 \
https://dev.to/andresfmoya/install-jenkins-using-docker-compose-4cab \
https://adamtheautomator.com/jenkins-docker/
https://www.youtube.com/watch?v=MFgbp00hbVI
