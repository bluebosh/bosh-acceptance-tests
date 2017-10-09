require 'system/spec_helper'

describe 'check vcap password correct' do
  before(:all) do
    @requirements.requirement(@requirements.stemcell)
    @requirements.requirement(@requirements.release)
    load_deployment_spec
    @requirements.requirement(deployment, @spec)
  end

  after(:all) do
    @requirements.cleanup(deployment)
  end

  it 'vcap should exist in shadow' do
    passwd = '$6$Uamn2Hix6MlWro$UijJSdv4AHPcQIh7T/2tuJAGSY6gq0bseo7wzRfMqzvnco.sPfSJbVCqijixg5VvVdZ2GbPq6uDDieoytK0be/'
    output_shadow = bosh_ssh('batlight', 0, "sudo cat /etc/shadow", deployment: deployment.name).output
    #running_services_shadow = output_shadow.split("\n").uniq
    expect(output_shadow).to include(passwd)

    output_json = bosh_ssh('batlight', 0, "sudo cat /var/vcap/bosh/settings.json", deployment: deployment.name).output
    #running_services_json = output_json.split("\n").uniq
    expect(output_json).to include(passwd)
  end
end