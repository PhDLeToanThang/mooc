<?php
/**
 * QNET Theme for Moodle 3.9.0
 * 
 * @package    theme_qnet
 * @copyright  2026 ATCOM & PhDLeToanThang
 * @license    http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */

defined('MOODLE_INTERNAL') || die();

/**
 * Plugin version and release
 * 
 * Version: YYYYMMDDXX
 * - YYYY: Year
 * - MM: Month  
 * - DD: Day
 * - XX: Sequential number (00-99)
 */
$plugin->version   = 2026050901;

/**
 * Moodle version requirement
 * 2020110901 = Moodle 3.9.0 release
 */
$plugin->requires  = 2020110901;

/**
 * Plugin component (must match directory name)
 */
$plugin->component = 'theme_qnet';

/**
 * Plugin maturity level
 * Possible values: MATURITY_ALPHA, MATURITY_BETA, MATURITY_RC, MATURITY_STABLE
 */
$plugin->maturity  = MATURITY_BETA;

/**
 * Plugin release/version display name
 */
$plugin->release   = '1.0.0 (Build: 20260509)';

/**
 * Plugin human-readable name
 */
$plugin->name      = 'QNET Theme';

/**
 * Plugin description
 */
$plugin->summary   = 'QNET is a modern, responsive Moodle theme based on Bootstrap framework with Vietnamese and English support.';

/**
 * Plugin author/creator
 */
$plugin->author    = 'PhDLeToanThang & ATCOM';

/**
 * Remote code base URL (GitHub repository)
 */
$plugin->codebase  = 'https://github.com/PhDLeToanThang/mooc/tree/feature/moodle-qnet-theme/moodle390/qnet-theme';

/**
 * Copyright information
 */
$plugin->copyright = '2026 ATCOM & PhDLeToanThang. All rights reserved.';

/**
 * License information
 */
$plugin->license   = 'GPL-3.0+';

/**
 * Supported Moodle features (capabilities and limitations)
 */
$plugin->supported = array(
    'moodle'  => array(3.9, 3.10, 3.11, 4.0, 4.1),
    'php'     => array('7.2', '7.3', '7.4', '8.0', '8.1'),
);

/**
 * Moodle branch information
 */
$plugin->branch    = 'MOODLE_39_STABLE';

/**
 * Git branch tracking
 */
$plugin->gitbranch = 'feature/moodle-qnet-theme';

/**
 * Dependencies (if any)
 */
$plugin->dependencies = array();

?>
