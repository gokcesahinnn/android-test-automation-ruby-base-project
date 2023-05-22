# <proje_ismi> Android App Test Otomasyon Projesi

Bu proje <proje_ismi> Android uygulamasının test otomasyonunu içermektedir.

# Tool stack

* **Ruby** - Development language
* **RubyMine IDE** - Development IDE
* **Allure** Multi-language test report tool
* **Cucumber** - Gherkin Syntax Framework
* **RSpec** - Assertion & Validation Framework
* **Appium** - Mobile APP Test Automation Tool

# Kurulumlar

* Kurulumlar için
  Confluence'ta [Android Test Otomasyon Kurulum](https://drive.google.com/file/d/1KMANE6reeWKMBjHo-ZNsHpt-gQhkknCn/view?usp=share_link)
  sayfasındaki adımlar takip edilmelidir.
* Proje repository'i [ig-android-test-automation](<remote_repository_link>) linkinden
  clone alınabilir.
* Gerekli kütüphanelerin yüklenilebilmesi için proje dizininde aşağıdaki komutlar çalıştırılır.
  ```
  gem install bundler
  bundle install
  ```

# Testlerin Çalıştırılması

1. IDE üzerinden yeşil RUN butonu ile senaryo ya da feature bazlı çalıştırılabilir.


2. Terminalden ilgili proje dizininde senaryo ismi ile çalıştırma:

   `cucumber --name "Successful login"`


3. Terminalden ilgili proje dizininde scenario ya da feature tag'i ile çalıştırma:

   `cucumber --tag @successful_login`


4. Local device ya da cloud device lab'da çalıştırmak için:

   `cucumber --tag @successful_login device_type=cloud_private`

# Raporlama
* Raporlama aracı olarak allure report kullanılmaktadır.


* Allure report oluşturmak için allure pc'nizde kurulu olmalıdır.

    * Mac kurulum

      `brew install allure`

    * Windows Kurulum

        * Powershell açılır. Aşağıdaki komut çalıştırılır. Scoop kurulumu yapılır.

          `iwr -useb get.scoop.sh | iex`

        * Scoop başarılı kurulduktan sonra komut satırı açılır. Aşağıdaki komut çalıştırılır. Allure kurulumu yapılır.

          `scoop install allure`


* Allure report generate etmek için proje dizininde oluşan allure-results folder yolu verilerek aşağıdaki komut çalıştırılır.

  `allure serve output/allure-results `


# Project Folder Structure

```
.
├── Gemfile                     #Projenin kullanılacak kütüphanelerin yönetimi
├── apps                        #İlgili apk'ların tutulduğu dizin
├── config                      #Projeye ait configürasyonlar
│   └── base_config.rb
├── context
│   ├── cart_context.rb
│   └── global_context.rb
├── model                       #Enum yapıları ve gerekli modeller tanımlamaları
│   └── product_category.rb
├── features
│   ├── pages                   #Page Object Model implementasyonu için kullanılacaktır
│   │   ├── home
│   │   │   ├── choose_address_page.rb
│   │   │   └── home_page.rb
│   │   ├── login
│   │   │   └── login_page.rb
│   │   ├── order
│   │   │   └── order_result_page.rb
│   ├── step_definitions        #Senaryolara ait step tanımlamalarının yapıldığı dizin
│   │   ├── home
│   │   │   ├── choose_address_steps.rb
│   │   │   └── home_steps.rb
│   │   ├── login
│   │   │   ├── login_e2e_steps.rb
│   │   │   └── login_steps.rb
│   │   ├── order
│   │   │   ├── order_e2e_steps.rb
│   │   │   └── order_result_steps.rb
│   ├── support                 #Hooks ve env tanımlamalarının yapıldığı dizin
│   │   ├── env.rb
│   │   ├── global.rb
│   │   └── hooks.rb
│   ├── tests                   #Gherkin Synxtaxı'ndaki senaryoların bulunduğu dizin
│   │   ├── checkout
│   │   │   ├── checkout.feature
│   │   │   └── coupon_code.feature
│   │   ├── home
│   │   │   ├── register.feature
│   │   │   └── search.feature
│   │   ├── login
│   │   │   └── login.feature
├── utils                       #Utils class ve metodların yer aldığı dizin
│   ├── driver_utils.rb
│   └── general_utils.rb
└── README.md
```

# Naming Convention

Proje genelinde `snack_case` yazım şekli takip edilecektir.

İsimlendirmeler yapılırken aşağıdaki durumlar takip edilecektir.

```
folder name = my_folder

ruby file name = my_file.rb

feature file name = my_feature.rb

class name = MyClass

method name = my_method

variable name = my_variable

element name = @my_element @my_element @my_element

Enum = ALL_CAPITAL = 'value'

Global variable = $MY_VAR

Config Constant = MY_CONSTANT

Feature name = my_feature

tag name = @my_tag 
```
Elementlerin locatorları tek tırnak ile tanımlanmalı, eğer iç içe tırnak kullanımı varsa dışta çift tırnak olacak şekilde tanımlanmalıdır.

*Örnek:*

@btn_edit_address = { id: 'tvEditAddress' }

@btn_dropdown_choice_by_text = { xpath: "//android.widget.TextView[@text='%s']" }
# Android Element Standartları

| Prefix        | Örnek        | Locator      |
| ------------- |--------------|------------- |
| btn           | btn_login    |  Button      |
| chk           | chk_status   |  Checkbox    |
| cbx           | cbx_english  |  Combo box   |
| lbl           | lbl_username |  Label       |
| drp           | drp_list     |  Drop down   |
| slc           | slc_list     |  Selectbox   |
| txt           | txt_email    |  Textbox     |
| img           | img_logo     |  Image       |
| rdx           | rdx_female   |  Radiobox    |

# Page Method Standartları

| Prefix | Action         | Description                |
|--------|----------------|----------------------------|
| click  | click_register | Click button or link       |
| fill   | fill_email     | Type textbox               |
| check  | check_gender   | Check a check box          |
| select | select_year    | Select value from drop down |
| verify | verify_menu    | Assertion                  |

# Senaryo Yazımı Standartları

* Senaryolar `feature` file içerisine yazılacaktır.
* ``Given, When, Then, And`` Syntax i kullanılacaktır.
* Feature file başlangıcında ``Feature`` keywordunden sonra ilgili feature ın isimlendirmesi yapılacaktır.
* Bir sonraki satırda feature in açıklaması yazılacaktır.
* Senaryolar ``Scenario`` keywordunden sonra yazılacaktır. Senaryo name unique olmalıdır.
* Her senaryo taglenmelidir. İlgili tagler senaryonun üst kısmına koyulmalıdır. @regression, @smoke gibi.
* Senaryo stepleri yazılırken aşağıdaki örnek senaryo takip edilecektir.

```gherkin
Given ön koşul
And ek koşul varsa
When aksiyonun alındığı kısım 
And ek aksiyon varsa
Then ilgili verifikasyonların yapıldığı yer
And ek verifikasyonlar 
```

**Scenario Örneği**

```gherkin
Given homepage is opened
And click login button
And fill the valid credentials
When click login button
Then verify my account icon
And verify the title is changed to "My Title"
```

# Step Definition Formulü

* action + object + location
```gherkin
And click login button on homepage
```
  


* action + object + value + location

```gherkin
And set email with "m@f.com" on homepage
```


* verification action + object + location

```gherkin
Then verify the new address on my delivery addresses page
```


* verification action + object + value + location

```gherkin
Then verify the new address title is "Home" on my delivery addresses page
```

# Ortak Kullanılan Stepler

Tüm proje genelinde geçerli olan test adımları base_step ve base_page'de tanımlıdır.
Base step'e yeni bir step eklerken bu stepin proje genelinde birden fazla sayfada kullanılması gereklidir.
Örnek olarak geri git butonu, bu adımı geç, hesabım butonu vs..

* Validations sayfasındaki mesaj (Ör: wrong_sms_code: 'Hatalı doğrulama kodu girdin.') + page adı

```gherkin
Then verify "wrong_sms_code" validation message on "login" page
```

* Sayfaların sol üstteki geri butonu

```gherkin
When click back button
```

# E2E ve Declerative Step Yazım Standartları

## E2E Step Tanımı
**E2E** stepler, tek bir step tanımı içerisinde bir işlemi uçtan uca kapsayan steplerdir. Örneğin loginden başlayıp
siparişlerin tamamlanmasına kadar olan bütün süreci kapsayan order senaryolarının birer step hâline indirgenmesi
E2E steplere örnek olabilir.

##E2E Step Yazımı
E2E stepler tanımlanırken, baş kısımlarına [E2E] ibaresi konmalıdır. Steplerin yazımı sırasında IDE tarafından önerilen
steplerin E2E olduğunu ve birden fazla eylemi içerdiğini anlamak açısından faydası dokunacaktır.

**Uyarı:** Köşeli parantezler RegEx motorlarında farklı anlamlara geldikleri için step tanımı içerisinde bu karakterler
kaçırılarak yazılmalıdır => \[E2E\]

### **Step Definition Örneği:**
```ruby
And(/^\[E2E\] order successfully by (craftgate) with logged in user$/) do |payment_type|
  home_page.click_login_button
  $user = get_user
  login_page.login($user[:phone_number])
  home_page.click_allow_button
           .select_category("fruits_vegy")
  category_page.select_sub_category("fruits_vegy", "fresh_vegy")
               .verify_select_sub_category
               .click_add_products_with_a_total_price_greater_than_value(quantity, "with_3d")
  home_page.click_go_to_my_cart
  cart_page.click_cart_confirm_button
  $card = get_valid_card
  checkout_page.select_payment_type(payment_type)
               .select_confirm_agreement
               .click_pay
               .fill_checkout_form_and_submit_on_iframe
  order_result_page.verify_order_complete_successfully
end
```

### Step Örneği

```gherkin
 @smoke @verify_merge_order
  Scenario: verify the order merged is completed successfully
    And [E2E] order successfully by craftgate with logged in user
    When add product to order on order result page
    And add a random product under fresh_fruit sub menu under fruits_vegy category to the cart
    And click cart confirm button on cart page
    And click merge order button on cart page
    And complete payment by craftgate with paraf master credit_card on checkout page
    Then verify the order merge is completed successfully on order result page
```
## Declerative Step Tanımı

Aynı sayfa üzerinde ardışık olarak gerçekleştirilen işlemlerin tek bir step altında toplanmasına **declerative step** denir.
Burada önemli nokta, declerative steplerin E2E stepler ile karıştırılmamasıdır. Declerative stepler tüm bir süreci uçtan
uca kapsamaz, yalnızca aynı page üzerinde ve ardışık olarak gerçekleştirilen işlemleri bir araya getirir.

### Declerative Step Örneği

```ruby
Given(/^add master pass (paraf|ziraat) (master|visa|troy) (credit_card|debit_card) on my credit cards page$/) do |card_name, card_payment_type, card_type|
    $card = get_valid_card(bank_name:card_name, card_payment_type:card_payment_type, card_type:card_type)
    my_cards_page.click_add_new_card_button
                 .fill_card_information($card[:card_name], $card[:card_number], $card[:expire_month], $card[:expire_year], $card[:cvv])
                 .click_save_card_button
                 .fill_verification_code
                 .verify_added_card_message($card[:card_name])
  end
```

# Tag Yönetimi

```
@wip = Developmentı henüz tamamlanmamış senaryo / feature
@smoke = Smoke kapsamında çalışması beklenen senaryo / feature
@excluded  = Uygulama üzerinde artık var olmayan ancak senaryosu geliştirilmiş senaryo / feature
@bug_fix = Uygulama üzerinde var olan bir bugdan dolayı bug fix bekleyen senaryo / feature 
           Aşağıdaki örnek gibi bug_id tagı ile birlikte kullanılmalıdır.
           Örnek Kullanım @bug_fix @bug_id_JIRA_ID 
@prod  = Prodda koşacak senaryolar
@regression  = Regresyon sırasında koşması gereken caseler
@feature_tag = Her bir feature dosyasına verilecek tag name. Örnek: @feature_login
@scenario_tag = Her bir senaryoya verilecek ve uniq olması beklenen tag. Örnek: @success_login
```

# Commit ve PR structure

```
* Branch isimleri işin ticket idsi ile açılmalı. Örnek: QA-74
* Mümkün olduğunca commitler anlaşılır açıklamalar ile commitlenmeli.
* Commit atılırken mümkün olduğunca küçük parçalar halinde ilerlenmeli(Atomic). Böylelikle rollback daha kolay olacaktır.
* PR QA ekibinden zorunlu review ırların review etmesinden sonra master a mergelenecektir.
* Master'a mergelenmeden önce pipeline ilgili branch üzerinde çalıştırılacak ve herhangi bir problem olmadığı doğrulanacaktır.

```

# Project Feature Tags

Bu başlık altında feature tag'leri saklanmaktadır. Her yeni feature dosyası oluşturulup yeni bir feature tag'i
oluşturulduğunda mutlaka buraya açıklaması ile eklenmelidir.

* **@feature_search** => Search yapmayla ilgili test senaryoları
