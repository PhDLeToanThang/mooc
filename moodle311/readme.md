# BigBlueButtonBN Activity Module for Moodle
_BigBlueButton is an open source web conferencing system that enables universities and colleges to deliver a high-quality learning experience to remote students._

_These instructions describe how to install the BigBlueButtonBN Activity Module for Moodle. This module is developed and supported by Blindside Networks, the company that started the BigBlueButton project in 2007._

## With the latest version of this plugin you can:

1. Create links in any course that can be used to create rooms/sessions in a BigBlueButton server
1. Specify join open/close dates that will appear in the Moodle calendar
1. Create a custom welcome messages that appears in the chat window when users join the session
1. Launch BigBlueButton in its own tab or window
1. Assign the role uses will have in BigBlueButton (moderator, viewer) per user or role in Moodle
1. Pre-upload presentations
1. Monitor the active sessions for the course and end any session (eject all users)
1. Record and playback your lectures
1. Access and manage recorded lectures
1. Import recording links from a different course, and more.

**Note:** that on previous versions of Moodle you will need to use the specific version of this plugin:
```table
Moodle Version	  Branch			Version
Moodle 2.0 - 2.5	v1.1-stable	v1.1.1 (2015062101)
Moodle 2.6 - 3.0	v2.0-stable	v2.0.4 (2015080611)
Moodle 2.7 - 3.4	v2.1-stable	v2.1.15 (2016051920)
Moodle 3.0 - 3.7	v2.2-stable	v2.2.13 (2017101021)
Moodle 3.2 - 3.10	v2.3-stable	v2.3.6 (2019042011)
Moodle 3.4 - 3.11	v2.4-stable	v2.4.9 (2019101016)
Moodle 3.11       v3.0-stable	v3.0.9 (2021101017)
Moodle 4.0        --			    moodle-core
```
1. As the version included as part of Moodle 4.0 core develops, it would be hard to maintain full compatibility with previous versions of this plugin. For this reason the last major release will be v3.0, which was written for Moodle 3.11 and 4.0.

1. This last version will be maintained and keep in pair with the Moodle 4.0 core version once it is released as stable, and it will be aligned to the Moodle project schedule for maintenance and support. But likely we will not see more new features added.

1. For those running earlier versions of Moodle, we'll keep supporting the previous versions with security patches up to v2.2-stable, and for bug fixes up to v2.4-stable.

1. We ecourage to update to the latest version of Moodle as soon as possible.

<hr></hr>

# Prerequisites:

**You need:**

1. A server running Moodle
1. A BigBlueButton 0.8 (or later) server running on a separate server (not on the same server as your Moodle site)
Blindside Networks provides you a test BigBlueButton server for testing this plugin. To use this test server, just accept the default settings when configuring the activity module. The default settings are

url: http://test-install.blindsidenetworks.com/bigbluebutton/

salt: 8cd8ef52e8e101574e400365b55e11a6

_Ref: For information on how to setup your own BigBlueButton server see_
