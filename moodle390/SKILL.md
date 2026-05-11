---
name: qnet_template
description: Create a qnet_template support Moodle 3.9.0+ (Self-hosted)
license: MIT
compatibility: opencode
metadata:
  audience: developers
  category: code-quality
---

## 🎯 What I do

## 1. Project Overview
name: qnet_template
Platform: Moodle 3.9.0+ (Self-hosted)
Base Theme: Boost (Standard Moodle 3.9)
Reference: https://atcom.vn/edu/QNET/qnet.readme_v1.2.html
Objective: Convert HTML5 reference to a standard Moodle theme with support for English (en) and Vietnamese (vi) languages.
Output Path: 'C:\Thanglt-Document-2026\2026\QNET\Moodle\qnet_template'

## 2. Analysis & Requirements
Core Technology: PHP 7.4+, Mustache Templates, SCSS.
Design System: Based on the reference HTML structure (Header, Footer, Main Content area).
Admin Settings: Must include a robust 'settings.php' to handle theme configurations without throwing "Class not found" errors.
Coding Standards:
  - No PHP comments at the very top of files (e.g., '// FILE: ...').
  - Strict Moodle 3.9 directory structure.
  - Support for 'theme_boost_admin_settingspage_blocks' logic (using standard Moodle admin_settingpage to ensure compatibility).

## 3. Workflow & Task List
Setup Directory Structure: Create folders 'lang', 'pix', 'style', 'templates', 'layout'.
Create Config Files: 'version.php' and 'config.php' to register the theme.
Develop Logic ('lib.php'): Handle SCSS pre-processing and standard theme functions.
Develop Settings ('settings.php'): Create the admin interface for theme options.
Create Language Files: Define strings in 'en' and 'vi'.
Develop Styles ('SCSS'): Import Boost and add custom QNET styling.
Develop Templates ('Mustache'): Override core layouts (Columns2, Frontpage, Drawers).
Packaging: Zip the folder structure correctly for deployment.

## 4. Directory Structure
'''text
qnet_template/
├── lang/
│   ├── en/
│   │   └── theme_qnet_template.php
│   └── vi/
│       └── theme_qnet_template.php
├── pix/
│   └── (favicon.ico, background images, etc.)
├── style/
│   ├── moodle.scss
│   └── styles.scss
├── templates/
│   ├── columns2.mustache
│   ├── frontpage.mustache
│   └── drawers.mustache
├── layout/
│   └── (Optional: specific layout files if needed)
├── config.php
├── lib.php
├── settings.php
└── version.php
'''

## 5. Source Code Implementation

### 5.1. 'version.php'
Defines theme version and dependencies.

'''php
<?php
defined('MOODLE_INTERNAL') || die();

$plugin->component = 'theme_qnet_template';
$plugin->version   = 2023101000; // YYYYMMDDXX
$plugin->requires  = 2020061500; // Moodle 3.9.0 release
$plugin->maturity  = MATURITY_ALPHA;
$plugin->release   = 'v1.0.0';
'''

### 5.2. 'config.php'
Theme configuration file.

'''php
<?php
defined('MOODLE_INTERNAL') || die();

$THEME->name = 'qnet_template';
$THEME->parents = ['boost'];
$THEME->sheets = [];
$THEME->editor_sheets = [];
$THEME->enable_dock = false;
$THEME->rendererfactory = 'theme_overridden_renderer_factory';
'''

### 5.3. 'lib.php'
Core functions for the theme.

'''php
<?php
defined('MOODLE_INTERNAL') || die();

function theme_qnet_template_get_main_scss_content($theme) {
    global $CFG;

    $scss = '';
    $filename = !empty($theme->settings->preset) ? $theme->settings->preset : null;
    $fs = get_file_storage();

    $context = context_system::instance();
    if ($filename && $file = $fs->get_file_by_hash($filename)) {
        $scss .= $file->get_content();
    } else {
        $scss .= file_get_contents($CFG->dirroot . '/theme/boost/scss/preset/default.scss');
    }

    return $scss . file_get_contents($CFG->dirroot . '/theme/qnet_template/style/scss/_overrides.scss');
}

function theme_qnet_template_get_pre_scss_content($theme) {
    global $CFG;

    $scss = '';
    $configurable = [
        'brandcolor' => 'primary',
        'secondarybrandcolor' => 'secondary'
    ];

    foreach ($configurable as $varname => $dataname) {
        $value = isset($theme->settings->{$dataname}) ? $theme->settings->{$dataname} : null;
        if (empty($value)) {
            continue;
        }
        $scss .= '$' . $varname . ': ' . $value . ";\n";
    }

    return $scss;
}
'''

### 5.4. 'settings.php'
Admin settings page configuration. This ensures no "Class not found" errors by using standard Moodle API.

'''php
<?php
defined('MOODLE_INTERNAL') || die();

if ($ADMIN->fulltree) {
    
    $page = new admin_settingpage('theme_qnet_template_general', get_string('generalheading', 'theme_qnet_template'));

    $page->add(new admin_setting_heading('theme_qnet_template_generalheading', get_string('generalheading', 'theme_qnet_template'), ''));

    // Brand Color Setting
    $name = 'theme_qnet_template/brandcolor';
    $title = get_string('brandcolor', 'theme_qnet_template');
    $description = get_string('brandcolor_desc', 'theme_qnet_template');
    $default = '#0f6cbf';
    $setting = new admin_setting_configcolourpicker($name, $title, $description, $default);
    $setting->set_updatedcallback('theme_reset_all_caches');
    $page->add($setting);

    // Logo Image Setting
    $name = 'theme_qnet_template/logo';
    $title = get_string('logo', 'theme_qnet_template');
    $description = get_string('logo_desc', 'theme_qnet_template');
    $setting = new admin_setting_configstoredfile($name, $title, $description, 'logo');
    $setting->set_updatedcallback('theme_reset_all_caches');
    $page->add($setting);

    $settings->add($page);
}
'''

### 5.5. 'lang/en/theme_qnet_template.php'
English language strings.

'''php
<?php
$string['pluginname'] = 'QNET Template';
$string['generalheading'] = 'General Settings';
$string['brandcolor'] = 'Brand color';
$string['brandcolor_desc'] = 'The primary color for the theme.';
$string['logo'] = 'Logo';
$string['logo_desc'] = 'Upload the main logo for the site.';
$string['region-side-pre'] = 'Right';
$string['region-side-post'] = 'Left';
'''

### 5.6. 'lang/vi/theme_qnet_template.php'
Vietnamese language strings.

'''php
<?php
$string['pluginname'] = 'Giao diện QNET';
$string['generalheading'] = 'Cài đặt chung';
$string['brandcolor'] = 'Màu thương hiệu';
$string['brandcolor_desc'] = 'Màu chủ đạo cho giao diện.';
$string['logo'] = 'Logo';
$string['logo_desc'] = 'Tải lên logo chính của trang web.';
$string['region-side-pre'] = 'Phải';
$string['region-side-post'] = 'Trái';
'''

### 5.7. 'style/moodle.scss'
Main SCSS entry point.

'''scss
// Import the standard Boost SCSS.
$boost-scoped: true;
@import "../boost/scss/moodle";
'''

### 5.8. 'style/styles.scss'
Custom overrides for QNET.

'''scss
// QNET Custom Styles
// Based on reference: https://atcom.vn/edu/QNET/qnet.readme_v1.2.html

body {
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    background-color: #f4f4f4;
}

// Header customization based on reference
#page-wrapper {
    margin-top: 0;
}

// Customizing the navbar
.navbar-light {
    background-color: var(--primary) !important;
}

// Footer customization
#page-footer {
    background-color: #333;
    color: #fff;
    padding: 20px 0;
}
'''

### 5.9. 'templates/columns2.mustache'
Layout for standard pages with a side block.

'''mustache
{{!
    This template is a duplicate of the Boost columns2 template with QNET specific placeholders.
}}
<div class="drawer-toggle {{#draweropenright}}drawer-open-right{{/draweropenright}} {{#draweropenleft}}drawer-open-left{{/draweropenleft}}"></div>

{{> theme_boost/head }}

<body {{{ bodyattributes }}}>

<div id="page-wrapper">

    {{{ output.standard_top_of_body_html }}}

    {{> theme_boost/navbar }}

    <div id="page" class="container-fluid d-print-block">
        <div class="row">
            <div id="region-main-box" class="col-12">
                {{#hasregionmainsettingsmenu}}
                <div id="region-main-settings-menu" class="d-print-none {{#hasblocks}}has-blocks{{/hasblocks}}">
                    <div> {{{ output.region_main_settings_menu }}} </div>
                </div>
                {{/hasregionmainsettingsmenu}}
                <section id="region-main" {{#hasblocks}}class="has-blocks mb-3"{{/hasblocks}}>
                    <div class="card card-block">
                        <div class="card-body">
                            {{{ output.course_content_header }}}
                            <div class="main-inner">
                                {{{ output.main_content }}}
                            </div>
                            {{{ output.course_content_footer }}}
                        </div>
                    </div>
                </section>
                {{#hasblocks}}
                <section class="d-print-none" data-region="blocks-column" aria-label="{{#str}}blocks{{/str}}">
                    {{{ sideblocks }}}
                </section>
                {{/hasblocks}}
            </div>
        </div>
    </div>

    {{> theme_boost/footer }}
</div>

</body>
</html>
'''

### 5.10. 'templates/frontpage.mustache'
Frontpage layout.

'''mustache
{{!
    Frontpage template for QNET.
}}
{{> theme_boost/head }}

<body {{{ bodyattributes }}}>

<div id="page-wrapper">

    {{{ output.standard_top_of_body_html }}}

    {{> theme_boost/navbar }}

    <div id="page" class="container-fluid d-print-block">
        <div id="page-content" class="row">
            <div id="region-main-box" class="col-12">
                <section id="region-main">
                    <div class="card card-block">
                        <div class="card-body">
                            <h2 class="text-center">Welcome to QNET Education</h2>
                            <div class="main-inner">
                                {{{ output.main_content }}}
                            </div>
                        </div>
                    </div>
                </section>
            </div>
        </div>
    </div>

    {{> theme_boost/footer }}

</div>

</body>
</html>
'''

### 5.11. 'templates/drawers.mustache'
Helper template for navigation drawers.

'''mustache
{{!
    Navigation drawer template.
}}
<div id="nav-drawer" data-region="drawer" class="d-print-none moodle-has-zindex">
    {{> theme_boost/nav-drawer }}
</div>
'''

## 6. Packaging Instructions

To deploy this theme to Moodle 3.9.0+:

1.  **Folder Structure:** Ensure all files are inside a folder named 'qnet_template'.
2.  **Compression:**
    *   Select the folder 'qnet_template'.
    *   Right-click and choose **7-Zip** > **Add to archive...**.
    *   Archive format: **zip**.
    *   Ensure the option "Create SFX archive" is **unchecked**.
    *   The resulting file should be named 'qnet_template_moodle39.zip'.
    *   **Crucial:** When opening the zip file, the first item visible must be the folder 'qnet_template', not loose files.
3.  **Installation:**
    *   Login to Moodle as Admin.
    *   Go to *Site administration > Plugins > Install plugins*.
    *   Upload the zip file.
    *   Install and then select "QNET Template" as the default theme in *Site administration > Appearance > Theme selector*.

## 7. Notes
- The code provided avoids comments at the top of PHP files to prevent header output errors.
- The 'settings.php' uses standard 'admin_settingpage' to prevent the "Class theme_boost_admin_settingspage_blocks not found" error, as that specific class is not part of the core Moodle API and relying on it causes issues. The provided code is the correct Moodle 3.9 standard.
- Language files support both English and Vietnamese as requested.
