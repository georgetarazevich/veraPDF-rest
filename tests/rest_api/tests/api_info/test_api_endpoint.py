import re
import requests
from tests.conftest import get_base_url
from tests.rest_api.model.api_info.api_endpoint import ApiEndpoint, ApiEndpointXml


id = "verapdf-rest"
buildDate_regex = re.compile(r"^[0-9]+$")
version_regex = re.compile(r"^[0-9]\.[0-9]\.[0-9]-SNAPSHOT")


def test_api_check(get_base_url):
    response = requests.get(get_base_url + "/api")
    assert response.status_code == 200

    resp = response.json()
    api = ApiEndpoint(**resp)

    assert api.id == id
    assert version_regex.match(api.version)
    assert buildDate_regex.match(str(api.buildDate))


def test_api_xml_check(get_base_url):
    url = get_base_url + "/api"
    headers = {"Accept": "application/xml"}

    response = requests.get(url=url, headers=headers)
    api = ApiEndpointXml.from_xml(response.text)

    assert api.id == id
    assert version_regex.match(api.version)
    assert buildDate_regex.match(str(api.buildDate))
