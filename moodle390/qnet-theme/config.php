<?php
/**
 * QNET Theme Configuration
 * 
 * Defines the theme structure, layouts, regions, and settings
 * 
 * @package    theme_qnet
 * @copyright  2026 ATCOM & PhDLeToanThang
 * @license    http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */

defined('MOODLE_INTERNAL') || die();

/**
 * Basic theme configuration
 */
$THEME->name = 'qnet';
$THEME->doctype = 'html5';
$THEME->parents = array('boost');
$THEME->enable_dock = true;
$THEME->mobilitheme = 'qnet';

/**
 * SCSS processing function
 * This function is called to process SCSS files after they are compiled
 */
$THEME->csspostprocess = 'theme_qnet_process_scss';

/**
 * Color preset configuration
 */
$THEME->presetsetting = 'theme_qnet_preset';
$THEME->presets = array(
    'default' => 'Default Blue',
    'dark'    => 'Dark Mode',
    'blue'    => 'Ocean Blue',
    'green'   => 'Forest Green',
);

/**
 * Theme regions (available block areas)
 * 
 * Regions define where blocks can be placed on pages
 * side-pre: Left sidebar
 * side-post: Right sidebar
 * content: Main content area
 * top: Top area
 * bottom: Bottom area
 */
$THEME->regions = array(
    'side-pre'      => 'Left',
    'side-post'     => 'Right',
    'top'           => 'Top',
    'bottom'        => 'Bottom',
);

/**
 * Layout definitions
 * 
 * Defines different page layouts and their associated:
 * - Template file (Mustache)
 * - Available regions
 * - Default region for new blocks
 */
$THEME->layouts = array(
    /**
     * Base layout - no header/footer
     */
    'base' => array(
        'file'           => 'base.mustache',
        'regions'        => array(),
        'defaultregion'  => null,
    ),

    /**
     * Standard layout - typical Moodle page
     */
    'standard' => array(
        'file'           => 'standard.mustache',
        'regions'        => array('side-pre', 'side-post'),
        'defaultregion'  => 'side-pre',
    ),

    /**
     * Front page layout - home page
     */
    'frontpage' => array(
        'file'           => 'frontpage.mustache',
        'regions'        => array('side-pre', 'side-post'),
        'defaultregion'  => 'side-pre',
    ),

    /**
     * Course page layout
     */
    'course' => array(
        'file'           => 'course.mustache',
        'regions'        => array('side-pre', 'side-post'),
        'defaultregion'  => 'side-pre',
    ),

    /**
     * In-course page layout (activities/resources)
     */
    'incourse' => array(
        'file'           => 'incourse.mustache',
        'regions'        => array('side-pre', 'side-post'),
        'defaultregion'  => 'side-pre',
    ),

    /**
     * Admin pages layout
     */
    'admin' => array(
        'file'           => 'admin.mustache',
        'regions'        => array('side-pre'),
        'defaultregion'  => 'side-pre',
    ),

    /**
     * Popup layout - modal/dialog content
     */
    'popup' => array(
        'file'           => 'popup.mustache',
        'regions'        => array(),
        'defaultregion'  => null,
    ),

    /**
     * Embedded layout - embedded pages
     */
    'embedded' => array(
        'file'           => 'embedded.mustache',
        'regions'        => array(),
        'defaultregion'  => null,
    ),

    /**
     * Print layout - for printing pages
     */
    'print' => array(
        'file'           => 'print.mustache',
        'regions'        => array(),
        'defaultregion'  => null,
    ),

    /**
     * Login page layout
     */
    'login' => array(
        'file'           => 'login.mustache',
        'regions'        => array(),
        'defaultregion'  => null,
    ),
);

/**
 * SCSS configuration
 * 
 * Defines paths to SCSS files and color presets
 */
$THEME->scss = array(
    /**
     * Variables SCSS file
     * Contains color variables, spacing, fonts, etc.
     */
    'variables' => 'scss/variables.scss',
    
    /**
     * Default color preset
     */
    'default' => 'scss/preset/default.scss',
);

/**
 * Font files support
 * Enable custom font inclusion
 */
$THEME->fontfiles = true;

/**
 * Image alt text support
 */
$THEME->showthumbnails = false;

/**
 * Sheet icons support (for block icons in block header)
 */
$THEME->sheeticons = 'yes';

/**
 * User agent detection
 * Allows specific styling for different browsers
 */
$THEME->useragent = array(
    'Chrome'   => 'webkit',
    'Safari'   => 'webkit',
    'Firefox'  => 'mozilla',
    'Opera'    => 'webkit',
    'Edge'     => 'webkit',
);

/**
 * Required capabilities
 * Users must have these capabilities to view/use the theme
 */
$THEME->requiredcapabilities = array();

/**
 * Custom CSS support
 * Allow custom CSS to be added via admin interface
 */
$THEME->usescourseimage = true;

/**
 * Favicon support
 */
$THEME->favicon = '/pix/favicon.ico';

/**
 * Favicon URL
 */
$THEME->faviconurl = '{pix}favicon.ico';

/**
 * Manifest file for PWA support (Progressive Web App)
 */
$THEME->manifest = true;

/**
 * Chart support
 */
$THEME->chart_default_colors = array(
    '#007bff', '#6c757d', '#28a745',
    '#dc3545', '#ffc107', '#17a2b8',
    '#343a40', '#003d82', '#00a8e8',
);

?>
