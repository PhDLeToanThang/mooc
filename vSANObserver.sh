#HƯỚNG DẪN CẤU HÌNH CÔNG CỤ GIÁM SÁT vSAN bằng vSAN Observer
#Giảng viên: Nguyễn Đức Tú.
#Người yêu cầu đề tài: PhD. Lê Toàn Thắng
#    Ruby vSphere Console – RVC là gì?
#    Bạn có thể tham khảo thêm trong tài liệu: VSAN-Troubleshooting-Reference-Manual
#vSAN Observer là gì? vSAN Observer là một trong số những công cụ giám sát và phát hiện các sự cố được tích hợp sẵn trong RVC. Nó giám sát SAN #ảo trong thời gian thực.
# 
#    Một số điều cần và đủ để khởi tạo và cấu hình vSAN Observer
#        vCenter Server Appliance đã được triển khai trên hệ thống ảo hóa của bạn.
#        Enable chế độ quản trị từ xa qua SSH trên VCVA.
#        Được phân quyền với đặc quyền như một user có thể login vào hệ thống VCVA với mục đích quản trị.
#        Do trong vCenter bản 6.0 có phần khác biệt so với các phiên bản thấp hơn như 5.1 hoặc 5.5, trước khi sử dụng tập lệnh để cấu hình bạn #phải khởi tạo môi trường shell đầu tiên.
#
#         
#    Các bước cấu hình chi tiết
#        Bước 1: Đăng nhập vào máy chủ cài đặt VCVA với chế độ quản trị từ xa SSH bằng root user và khởi tạo môi trường
#            login as: root
#            VMware vCenter Server Appliance 6.0.0
#            Type: vCenter Server with an embedded Platform Services Controller
#            root@172.20.10.94’s password:
#            Last login: Sat May 28 18:08:36 2016 from cc.vsan.local
#            Connected to service
#            * List APIs: “help api list”
#            * List Plugins: “help pi list”
#            * Enable BASH access: “shell.set –enabled True”
#            * Launch BASH: “shell”
#            Command>
#            Khởi tạo môi trường làm việc Shell:
#            Command> shell.set –enable true
#            Command> shell
#            ———- !!!! WARNING WARNING!!!! ———-
#            Your use of “pi shell” has been logged!
#            The “pi shell” is intended for advanced troubleshooting operations and while
#           supported in this release, is a deprecated interface, and may be removed in a
#           future version of the product. For alternative commands, exit the “pi shell”
#           and run the “help” command.
#           The “pi shell” command launches a root bash shell. Commands within the shell
#           are not audited, and improper use of this command can severely harm the
#           system.
#           Help us improve the product! If your scenario requires “pi shell,” please
#           submit a Service Request, or post your scenario to the
#           communities.vmware.com/community/vmtn/server/vcenter/cloudvm forum.
#           vcva01:~ #
#       Bước 2: Đăng nhập vào Ruby vSphere Console (RVC)
#       vcva01:/ # rvc administrator@vsphere.local@localhost
#       WARNING: Nokogiri was built against LibXML version 2.7.6, but has dynamically loaded 2.9.1
#       The authenticity of host ‘localhost’ can’t be established.
#       Public key fingerprint is 5237f31c1a93b351844522d4245461b2243169723f1aae8827ec442bb01ae6ba.
#     Are you sure you want to continue connecting (y/n)? y
#       Warning: Permanently added ‘localhost’ (vim) to the list of known hosts
#       password:
#       Welcome to RVC. Try the ‘help’ command.
#       0 /
#        1 localhost/
#       >
#       Bước 3: Khởi động Virtual SAN Observer Live
#            Sau khi đăng nhập thành công vào RVC, bạn đang ở thư mục hiện tại là / (thư mục gốc)
#           Do việc cấu hình và enable vSAN được thực hiện ở mức Cluster nên tiếp theo bạn phải di chuyển đến thư mục cluster bằng câu lệnh:
#           cd /localhost/Datacenter/computers/vsan.local>
#           Trong đó: vsan.local là tên cluster
#
#            Khởi động vSAN Observer bằng câu lệnh sau:
#            /localhost/Datacenter/computers/vsan.local> vsan.observer ~/computers/vsan.local –run-webserver –force
            
#            Couldn’t load gnuplot lib
#            2016-05-29 09:55:12 +0000: Spawning HTTPS server
#            2016-05-29 09:55:12 +0000: Using certificate file: /etc/vmware-vpx/ssl/rui.crt
#            2016-05-29 09:55:12 +0000: Using private key file: /etc/vmware-vpx/ssl/rui.key
#            [2016-05-29 09:55:12] INFO WEBrick 1.3.1
#            [2016-05-29 09:55:12] INFO ruby 1.9.2 (2011-07-09) [x86_64-linux]
#            [2016-05-29 09:55:12] WARN TCPServer Error: Address already in use – bind(2)
#            [2016-05-29 09:55:12] INFO
#            Certificate:
#            Data:
#            Version: 3 (0x2)
#            Serial Number:
#            e2:46:f5:46:c4:a9:11:ba
#            Signature Algorithm: sha256WithRSAEncryption
#            Issuer: CN=CA, DC=vsphere, DC=local, C=US, O=vcva01.vsan.local
#            Validity
#            Not Before: May 6 04:18:34 2016 GMT
#            Not After : May 1 04:18:34 2026 GMT
#            Subject: CN=vcva01.vsan.local, C=US
#            Subject Public Key Info:
#            Public Key Algorithm: rsaEncryption
#            RSA Public Key: (2048 bit)
#            Modulus (2048 bit):
#            00:dd:02:b2:1b:7d:b8:ba:64:6d:cb:b8:95:66:52:
#            2d:0d:dd:97:cb:aa:26:01:2c:e6:2e:f0:ae:e8:e4:
#            9a:1f:39:65:46:13:87:25:e2:95:b0:32:58:87:78:
#            46:41:99:3a:cf:a1:5e:2c:5b:c7:ce:30:95:87:67:
#            8e:0b:89:69:69:9c:03:ea:eb:d9:29:7a:ab:f1:e3:
#            33:74:95:0d:17:2b:2a:1c:6c:ee:bf:05:fe:14:06:
#            9c:7f:19:8e:3e:0d:5a:00:36:ea:9b:fb:9e:83:55:
#            92:49:fb:b9:3a:1c:ff:6f:3b:56:50:92:1c:05:be:
#            b6:94:5d:43:f5:98:c8:a6:22:46:69:14:50:82:30:
#            51:11:81:23:1c:8e:a0:b4:9d:11:99:7d:77:f5:3f:
#            5b:02:12:02:72:5b:b3:8f:fe:ee:81:24:69:0b:e3:
#            ce:92:bb:85:92:0b:51:c9:53:f8:f7:a1:de:1b:4c:
#            3f:21:b2:32:69:67:58:15:1c:1a:61:c6:f4:ad:0c:
#            94:15:fe:f1:b1:7b:72:6a:e0:82:77:d0:7b:9a:6e:
#            89:ee:8d:61:e3:b8:2d:c2:49:43:b2:44:34:00:00:
#            bb:e8:7d:75:ca:21:46:fc:31:ac:af:8e:90:d3:6e:
#            8f:36:4a:41:f2:23:03:01:d4:63:80:ab:48:1e:05:
#            0d:13
#            Exponent: 65537 (0x10001)
#            X509v3 extensions:
#            X509v3 Subject Alternative Name:
#            DNS:vcva01.vsan.local
#            X509v3 Subject Key Identifier:
#            E6:7A:C4:D5:17:7B:2A:E3:76:26:58:2A:CE:A1:44:90:B0:4D:51:55
#            X509v3 Authority Key Identifier:
#            keyid:31:B9:16:05:F6:05:45:89:0C:4E:BE:9D:78:EE:0E:49:9A:FF:C9:BC
#         
#            Signature Algorithm: sha256WithRSAEncryption
#            99:c2:70:1c:e3:6e:33:db:8b:c0:f2:55:7b:ac:e8:2e:13:54:
#            70:27:b8:9f:0e:63:21:6d:60:75:2a:06:01:f9:3f:cb:88:2e:
#            b4:96:d5:08:91:47:77:93:1e:33:d0:b3:fd:2a:13:20:5f:cb:
#            6b:c0:c4:09:2b:ca:fa:d7:d9:59:32:4e:3e:48:a8:2a:0f:0e:
#            43:f8:6f:7e:3a:a2:a5:b1:f8:ac:85:24:fb:18:29:1b:00:61:
#            b5:51:a8:53:0d:d6:f7:26:87:29:ff:b8:7e:6b:1c:9b:cb:32:
#            67:6c:ad:44:a6:f7:dd:d4:75:79:b7:2b:eb:da:1e:fd:63:d5:
#            db:de:80:5e:b4:15:e2:e6:59:50:6b:30:5a:07:73:37:42:1b:
#            af:c1:90:a2:40:ec:d7:44:98:10:3a:6b:06:33:da:f5:23:36:
#            c1:a5:d2:a9:81:2f:56:a4:1f:32:95:cb:d9:6a:21:5b:15:ce:
#            77:ba:25:13:f9:3a:cc:36:da:0c:f1:92:eb:54:51:4a:11:2b:
#            c6:aa:63:00:9c:f0:dc:68:4c:14:50:d0:ce:d5:34:88:ac:02:
#            5c:44:c7:dd:88:2d:7c:77:ec:6c:4e:23:30:7b:32:8c:ff:61:
#            87:80:44:67:3a:66:f8:48:fd:41:37:7b:c5:f5:df:42:ae:2a:
#            51:04:e8:f7
#            Press <Ctrl>+<C> to stop observing at any point …
#			[2016-05-29 09:55:12] INFO WEBrick::HTTPServer#start: pid=24469 port=8010
#            2016-05-29 09:55:12 +0000: Collect one inventory snapshot
#            Query VM properties: 0.34 sec (1 VMs)
#            Query Stats on 172.20.10.51: 1.54+1.68 sec (on ESX: 1.11, json size: 144KB)
#            Query Stats on 172.20.10.52: 5.36+0.71 sec (on ESX: 0.12, json size: 144KB)
#            Query Stats on 172.20.10.53: 9.91+0.73 sec (on ESX: 0.11, json size: 143KB)
#            Query CMMDS from 172.20.10.51: 0.79 sec (json size: 8KB)
#            2016-05-29 09:55:23 +0000: Live-Processing inventory snapshot
#            2016-05-29 09:55:23 +0000: Collection took 11.62s, sleeping for 48.38s
#            2016-05-29 09:55:23 +0000: Press <Ctrl>+<C> to stop observing
#			
#        Bước 4: Truy cập vào giao diện đồ họa thông qua chế độ web view
#  Trong khi câu lệnh đang chạy, bạn có thể thực hiện monitoring vSAN thông qua đường link: http://vCenterServer_hostname_or_IP_Address:8010
#            https://vcva01.vsan.local:8010/
#    Thực hiện đăng nhập bằng administrator user của vsphere.local domain.