require 'test_helper'
require 'helpers/dir_request_stub'
require 'helpers/rmdir_request_stub'
require 'fog/akamai/storage_test_base'

module Fog
  module Storage
    class DirectoryTest < StorageTestBase
      include DirRequestStub
      include RmdirRequestStub

      def test_destroy_will_call_rmdir_with_the_correct_path
        stub_dir('/42/path')
        rmdir = stub_rmdir('/42/path')

        directory = storage.directories.get('/path')
        directory.destroy

        assert_requested rmdir
      end
    end
  end
end
