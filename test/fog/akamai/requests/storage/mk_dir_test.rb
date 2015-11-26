require 'test_helper'
require 'helpers/mk_dir_request_stub'
require 'timecop'
require 'fog/akamai/requests/storage_test_base'

module Fog
  module Storage
    class MkDirTest < StorageTestBase
      include MkDirRequestStub

      def test_mk_dir_without_path_will_fail
        assert_raises(ArgumentError) { storage.mk_dir(nil) }
        assert_raises(ArgumentError) { storage.mk_dir('') }
      end

      def test_mk_dir_calls_correct_host_and_path
        stub_mk_dir = stub_mk_dir('/42/test')
        storage.mk_dir('/test')
        assert_requested stub_mk_dir
      end
    end

    class MockMkDirTest < MockStorageTestBase
      def test_mock_without_path_will_fail
        assert_raises(ArgumentError) { storage.mk_dir(nil) }
        assert_raises(ArgumentError) { storage.mk_dir('') }
      end

      def test_mock_with_path_will_create_dir
        storage.mk_dir('/test')
        assert_equal({ directory: '/42/test', files: [], directories: [] }, storage.data['/42/test'])
      end

      def test_mock_with_composed_path_will_create_dir
        Timecop.freeze(Time.at(42)) do
          storage.mk_dir('/test/composed')
        end

        assert_equal({ directory: '/42/test', files: [], directories: [{ 'type' => 'dir', 'name' => 'composed', 'mtime' => '42' }] }, storage.data['/42/test'])
        assert_equal({ directory: '/42/test/composed', files: [], directories: [] }, storage.data['/42/test/composed'])
      end

      def test_mock_will_add_directories
        Timecop.freeze(Time.at(42)) do
          storage.mk_dir('/test/stop')
          storage.mk_dir('/test/whatsthatsound')
        end

        child = { 'type' => 'dir', 'name' => 'whatsthatsound', 'mtime' => '42' }
        other_child = { 'type' => 'dir', 'name' => 'stop', 'mtime' => '42' }
        assert_equal({ directory: '/42/test', files: [], directories: [other_child, child] }, storage.data['/42/test'])
      end
    end
  end
end
