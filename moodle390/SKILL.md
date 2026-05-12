---
name: moodle390
description: EXECUTOR MODE moodle 3.9.0 Theme Development Project QNET Template
license: MIT
compatibility: opencode
mode: executor
output_policy: full-content-only
---

## What I do

- SKILL.md (Final Version - Eguru Structure Based)
- Project: Project Skills - QNET Moodle Theme (Eguru Architecture)  
- Target: Moodle 3.9.0+ (Bootstrap 4) 
- Input: https://atcom.vn/edu/QNET/qnet.readme_v1.2.html 
- Documents:  https://docs.moodle.org/dev/Creating_a_custom_theme,
and https://support.moodle.com/support/solutions/articles/80000831609-moodlecloud-themes-and-customising-your-site  
- Reference: Theme Eguru Structure & Moodle Boost API: C:\Thanglt-Document-2026\2026\QNET\Moodle\eguru hoặc https://github.com/PhDLeToanThang/mooc/tree/master/moodle402/eguru 
- Objectie: Tạo đầy đủ source code files ở thư mục theme 'qnet_template' có đầy đủ Admin Settings (chia theo tab), Renderer chuẩn, và khả năng chọn theme ngay lập tức mà không gây lỗi ở thư mục: C:\Thanglt-Document-2026\2026\QNET\Moodle\qnet_template.

---

## Phase 1: Phân tích Cấu trúc Eguru & Khắc phục lỗi

### 1.1. Tại sao phiên bản trước thất bại?
*   Thiếu cấu trúc Settings: 'eguru' không dùng một trang settings đơn giản mà dùng hệ thống Tabs (General, Footer, Social...). Code trước quá đơn giản nên Moodle không hiển thị đủ tùy chọn.
*   Lỗi Renderer: Theme 'eguru' và các theme phức tạp cần định nghĩa rõ ràng class Renderer trong 'lib.php' để tránh xung đột khi chuyển đổi theme.
*   SCSS Injection: 'eguru' cho phép đổi màu qua Admin. Nếu thiếu hàm 'theme_qnet_template_get_pre_scss_content' trong 'lib.php', file CSS sẽ không được biên dịch đúng, dẫn đến giao diện vỡ.

### 1.2. Cấu trúc Mới (Theo chuẩn Eguru)
Chúng ta sẽ chia 'settings.php' thành các trang con (pages) và gom chúng vào một trang chính. Cấu trúc file sẽ như sau:

```
qnet_template/
├── config.php
├── lib.php              (Chứa Renderer & SCSS Logic)
├── settings.php         (Chứa các Tab cấu hình: General, Footer...)
├── version.php
├── lang/
│   ├── en/theme_qnet_template.php
│   └── vi/theme_qnet_template.php
├── scss/
│   └── preset.scss
├── layout/
│   ├── columns2.php
│   └── frontpage.php
└── pix/
    └── favicon.ico
```

---

## Phase 2: Toàn bộ Source Code (Full Source Code)

Hãy tạo các file sau với nội dung chính xác. Lưu ý: Không có dòng chú thích ở đầu file PHP.

### 1. File: 'version.php'
Đảm bảo phiên bản tương thích Moodle 3.9.

```php
<?php
defined('MOODLE_INTERNAL') || die();

$plugin->component = 'theme_qnet_template';
$plugin->version   = 2023120300;
$plugin->requires  = 2020061500; // Moodle 3.9.0
$plugin->maturity  = MATURITY_STABLE;
$plugin->release   = 'v1.2.0 (Eguru Based)';
```

### 2. File: 'config.php'
Khai báo theme cha là Boost và bật hỗ trợ SCSS.

```php
<?php
defined('MOODLE_INTERNAL') || die();

$THEME->name = 'qnet_template';
$THEME->parents = ['boost'];

$THEME->sheets = [];
$THEME->supports_sass = true;
$THEME->scssfile = 'preset.scss';

$THEME->rendererfactory = 'theme_overridden_renderer_factory';

$THEME->addblockposition = BLOCK_ADDBLOCK_POSITION_DEFAULT;
$THEME->hassidepre = true;
$THEME->hassidepost = true;
```

### 3. File: 'lib.php' (QUAN TRỌNG - Logic Eguru)
File này xử lý việc đưa màu sắc từ Admin vào SCSS và định nghĩa Renderer chuẩn để tránh lỗi.

```php
<?php
defined('MOODLE_INTERNAL') || die();

function theme_qnet_template_get_pre_scss_content($theme) {
    global $CFG;
    $scss = '';
    // Lấy cấu hình màu sắc từ Admin Settings
    $configurable = [
        'brandcolor' => 'primary',
        'secondarycolor' => 'secondary',
    ];
    foreach ($configurable as $configkey => $variableskey) {
        $value = $theme->get_setting($configkey);
        if (empty($value)) {
            continue;
        }
        $scss .= '$' . $variableskey . ': ' . $value . ";\n";
    }
    return $scss;
}

function theme_qnet_template_get_main_scss_content($theme) {
    global $CFG;
    $scss = '';
    $filename = $CFG->dirroot . '/theme/qnet_template/scss/preset.scss';
    if (file_exists($filename)) {
        $scss = file_get_contents($filename);
    }
    return $scss;
}

class theme_qnet_template_core_renderer extends \theme_boost\output\core_renderer {
    // Kế thừa chuẩn từ Boost renderer
}
```

### 4. File: 'settings.php' (QUAN TRỌNG - Cấu trúc Tab như Eguru)
File này tạo ra các tab cấu hình: General, Footer, Social.

```php
<?php
defined('MOODLE_INTERNAL') || die();

// Trang cấu hình chính cho theme
$settings = new theme_boost_admin_settingspage_blocks('theme_qnet_template', get_string('configtitle', 'theme_qnet_template'));

// --- TAB: GENERAL SETTINGS ---
$page = new admin_settingpage('theme_qnet_template_general', get_string('generalsettings', 'theme_qnet_template'));

// Brand Color
$name = 'theme_qnet_template/brandcolor';
$title = get_string('brandcolor', 'theme_qnet_template');
$description = get_string('brandcolor_desc', 'theme_qnet_template');
$default = '#1a84e6';
$setting = new admin_setting_configcolourpicker($name, $title, $description, $default, null);
$setting->set_updatedcallback('theme_reset_all_caches');
$page->add($setting);

// Logo
$name = 'theme_qnet_template/logo';
$title = get_string('logo', 'theme_qnet_template');
$description = get_string('logodesc', 'theme_qnet_template');
$setting = new admin_setting_configstoredfile($name, $title, $description, 'logo');
$setting->set_updatedcallback('theme_reset_all_caches');
$page->add($setting);

$settings->add($page);

// --- TAB: FOOTER SETTINGS ---
$page = new admin_settingpage('theme_qnet_template_footer', get_string('footersettings', 'theme_qnet_template'));

// Phone
$name = 'theme_qnet_template/phone';
$title = get_string('phone', 'theme_qnet_template');
$description = get_string('phonedesc', 'theme_qnet_template');
$default = '';
$setting = new admin_setting_configtext($name, $title, $description, $default, PARAM_NOTAGS);
$page->add($setting);

// Email
$name = 'theme_qnet_template/email';
$title = get_string('email', 'theme_qnet_template');
$description = get_string('emaildesc', 'theme_qnet_template');
$default = '';
$setting = new admin_setting_configtext($name, $title, $description, $default, PARAM_EMAIL);
$page->add($setting);

$settings->add($page);
```

### 5. File: 'lang/en/theme_qnet_template.php'
Ngôn ngữ đầy đủ cho các tab.

```php
<?php
$string['configtitle'] = 'QNET Template';
$string['pluginname'] = 'QNET Template';
$string['generalsettings'] = 'General Settings';
$string['footersettings'] = 'Footer Settings';
$string['brandcolor'] = 'Brand Color';
$string['brandcolor_desc'] = 'Select the main brand color.';
$string['logo'] = 'Logo';
$string['logodesc'] = 'Upload a custom logo.';
$string['phone'] = 'Phone Number';
$string['phonedesc'] = 'Contact phone number in footer.';
$string['email'] = 'Email Address';
$string['emaildesc'] = 'Contact email address in footer.';
$string['region-side-pre'] = 'Left';
$string['region-side-post'] = 'Right';
```

### 6. File: 'lang/vi/theme_qnet_template.php'
Bản dịch tiếng Việt.

```php
<?php
$string['configtitle'] = 'Giao diện QNET';
$string['pluginname'] = 'QNET Template';
$string['generalsettings'] = 'Cài đặt chung';
$string['footersettings'] = 'Cài đặt chân trang';
$string['brandcolor'] = 'Màu thương hiệu';
$string['brandcolor_desc'] = 'Chọn màu chủ đạo cho website.';
$string['logo'] = 'Logo';
$string['logodesc'] = 'Tải lên logo tùy chỉnh.';
$string['phone'] = 'Số điện thoại';
$string['phonedesc'] = 'Số điện thoại hiển thị ở chân trang.';
$string['email'] = 'Địa chỉ Email';
$string['emaildesc'] = 'Địa chỉ email hiển thị ở chân trang.';
$string['region-side-pre'] = 'Bên trái';
$string['region-side-post'] = 'Bên phải';
```

### 7. File: 'scss/preset.scss'
File SCSS xử lý màu sắc động.

```scss
// Import Boost variables
@import "../../boost/scss/variables";

// QNET Custom Styles
body {
    background-color: #f8f9fa;
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
}

// Header Styles
#page-header {
    background-color: $primary;
    color: #fff;
    .page-context-header {
        h1 {
            color: #fff;
        }
    }
    .navbar-light .navbar-brand {
        color: rgba(255,255,255,0.9);
    }
}

// Footer Styles
.qnet-footer {
    background-color: #212529;
    color: #adb5bd;
    padding: 3rem 0;
    margin-top: 2rem;
    a {
        color: #fff;
        &:hover {
            color: $primary;
        }
    }
}

// Import default preset to keep Boost functionality
@import "../../boost/scss/preset";
```

### 8. File: 'layout/frontpage.php'
Layout trang chủ chuẩn, hiển thị Logo tùy chỉnh.

```php
<?php
echo $OUTPUT->doctype() ?>
<html <?php echo $OUTPUT->htmlattributes(); ?>>
<head>
    <title><?php echo $OUTPUT->page_title(); ?></title>
    <link rel="shortcut icon" href="<?php echo $OUTPUT->favicon(); ?>" />
    <?php echo $OUTPUT->standard_head_html() ?>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>

<body <?php echo $OUTPUT->body_attributes(); ?>>

<?php echo $OUTPUT->standard_top_of_body_html() ?>

<header id="page-header">
    <div class="container">
        <div id="page-navbar" class="d-print-none">
            <nav class="navbar navbar-light bg-white shadow-sm">
                <div class="container-fluid">
                    <a href="<?php echo $CFG->wwwroot; ?>" class="navbar-brand d-flex align-items-center">
                        <?php
                        $logo = $OUTPUT->get_logo();
                        if ($logo) {
                            echo '<img src="' . $logo . '" alt="Logo" height="40">';
                        } else {
                            echo $SITE->shortname;
                        }
                        ?>
                    </a>
                    <?php echo $OUTPUT->user_menu(); ?>
                </div>
            </nav>
        </div>
        <div class="header-content py-4 text-white" style="background-color: var(--primary);">
            <h1 class="h3"><?php echo $OUTPUT->page_heading(); ?></h1>
        </div>
    </div>
</header>

<div id="page" class="container-fluid mt-4">
    <div id="page-content" class="row">
        <div id="region-main-box" class="col-12">
            <section id="region-main" class="col-12">
                <?php
                echo $OUTPUT->course_content_header();
                echo $OUTPUT->main_content();
                echo $OUTPUT->course_content_footer();
                ?>
            </section>
        </div>
    </div>
</div>

<footer id="page-footer" class="qnet-footer">
    <div class="container">
        <div class="row">
            <div class="col-md-6">
                <h5><?php echo $SITE->fullname; ?></h5>
                <p><?php echo $SITE->summary; ?></p>
            </div>
            <div class="col-md-6 text-md-right">
                <h5>Contact Us</h5>
                <ul class="list-unstyled">
                    <?php
                    $phone = get_config('theme_qnet_template', 'phone');
                    $email = get_config('theme_qnet_template', 'email');
                    if ($phone) echo '<li><i class="icon fa fa-phone"></i> ' . s($phone) . '</li>';
                    if ($email) echo '<li><i class="icon fa fa-envelope"></i> ' . s($email) . '</li>';
                    ?>
                </ul>
            </div>
        </div>
        <hr class="border-light">
        <?php echo $OUTPUT->standard_footer_html(); ?>
    </div>
</footer>

<?php echo $OUTPUT->standard_end_of_body_html() ?>

</body>
</html>
```

### 9. File: 'layout/columns2.php'
Layout 2 cột chuẩn.

```php
<?php
echo $OUTPUT->doctype() ?>
<html <?php echo $OUTPUT->htmlattributes(); ?>>
<head>
    <title><?php echo $OUTPUT->page_title(); ?></title>
    <link rel="shortcut icon" href="<?php echo $OUTPUT->favicon(); ?>" />
    <?php echo $OUTPUT->standard_head_html() ?>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>

<body <?php echo $OUTPUT->body_attributes(); ?>>

<?php echo $OUTPUT->standard_top_of_body_html() ?>

<header id="page-header">
    <div class="container">
        <div id="page-navbar" class="d-print-none">
            <nav class="navbar navbar-light bg-white shadow-sm">
                <div class="container-fluid">
                    <a href="<?php echo $CFG->wwwroot; ?>" class="navbar-brand d-flex align-items-center">
                        <?php
                        $logo = $OUTPUT->get_logo();
                        if ($logo) {
                            echo '<img src="' . $logo . '" alt="Logo" height="40">';
                        } else {
                            echo $SITE->shortname;
                        }
                        ?>
                    </a>
                    <?php echo $OUTPUT->user_menu(); ?>
                </div>
            </nav>
        </div>
        <div class="header-content py-3">
            <?php echo $OUTPUT->context_header(); ?>
        </div>
    </div>
</header>

<div id="page" class="container-fluid mt-4">
    <div id="page-content" class="row">
        <div id="region-main-box" class="col-xl-9 col-sm-12 order-1">
            <?php echo $OUTPUT->blocks('side-pre', 'd-block d-md-none'); ?>
            <section id="region-main">
                <?php
                echo $OUTPUT->course_content_header();
                echo $OUTPUT->main_content();
                echo $OUTPUT->course_content_footer();
                ?>
            </section>
            <?php echo $OUTPUT->blocks('side-post', 'd-block d-md-none'); ?>
        </div>
        <?php
        if (right_to_left()) {
            echo $OUTPUT->blocks('side-pre', 'col-xl-3 col-sm-12 order-0 d-none d-md-block');
        } else {
            echo $OUTPUT->blocks('side-pre', 'col-xl-3 col-sm-12 order-2 d-none d-md-block');
        }
        ?>
    </div>
</div>

<footer id="page-footer" class="qnet-footer">
    <div class="container">
        <?php echo $OUTPUT->standard_footer_html(); ?>
    </div>
</footer>

<?php echo $OUTPUT->standard_end_of_body_html() ?>

</body>
</html>
```

---

## Phase 3: Quy trình Đóng gói & Cài đặt (Packaging)

1.  Kiểm tra thư mục: Đảm bảo tất cả các file trên nằm trong thư mục 'qnet_template'.
2.  Đóng gói ZIP:
    *   Chọn toàn bộ nội dung bên trong thư mục 'qnet_template'.
    *   Nén thành file 'qnet_template_moodle_390.zip'.
    *   Lưu ý: Bên trong file zip phải có thư mục 'qnet_template', không được để file nằm lỏng lẻo ở gốc zip.
3.  Cài đặt:
    *   Vào Site administration > General > Plugins > Install plugins.
    *   Tải file zip lên và cài đặt.
    *   Sau khi cài đặt, vào Site administration > Notifications để cập nhật Database.
4.  Kích hoạt & Kiểm tra:
    *   Vào Site administration > Appearance > Themes > Theme selector.
    *   Tìm "QNET Template" và nhấn "Use theme".
    *   Vào Site administration > Appearance > Themes > QNET Template settings.
    *   Bây giờ bạn sẽ thấy 2 tab: General Settings và Footer Settings.
    *   Thử đổi màu "Brand Color" và nhập thông tin "Phone/Email", sau đó nhấn Save changes.
    *   Vào Site administration > Development > Purge all caches để thấy thay đổi màu sắc.

