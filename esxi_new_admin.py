#!/usr/bin/python -u
from vmware.vapi.bindings.stub import ApiClient
from vmware.vapi.lib.connect import get_connector
from vmware.vapi.security.oauth \
   import create_oauth_security_context
from vmware.vapi.security.user_password \
   import create_user_password_security_context
from vmware.vapi.stdlib.client.factories import StubConfigurationFactory
import com.vmware.esx.authentication_client as authentication_client
import com.vmware.esx.authentication.trust_client as trust_client
import getpass
NEW_USER=input("Enter the name of the new user: ")
ROOT_PASSWORD=getpass.getpass("Enter 'root' password: ")
connector = get_connector("http", "json", url='http://localhost/api')
stubConfig = StubConfigurationFactory.new_std_configuration(connector)
connector.set_security_context(
   create_user_password_security_context("root", ROOT_PASSWORD))
token = ApiClient(authentication_client.StubFactory(stubConfig))
jwt = token.Token.create()
connector.set_security_context(
    create_oauth_security_context(jwt.access_token))
client_profiles = ApiClient(authentication_client.StubFactory(stubConfig))
cp = client_profiles.ClientProfiles
cpid = cp.create(cp.CreateSpec(local_user_name=NEW_USER, grants=[
    cp.AccessGrant(cp.ResourceType.ENTITLEMENT,
    cp.Entitlement.IDENTITY_MGMT)]))