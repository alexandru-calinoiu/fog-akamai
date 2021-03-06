module Fog
  module Storage
    class Akamai
      class Real
        require 'fog/akamai/parsers/storage/du'

        # Use this action to return disk usage information for the directory specified by the
        # @path, including all files stored in any sub-directories that may exist.
        # @param path [String] the path for the file that will be downloaded
        # @return [Excon::Response] response:
        #   * body [Hash]:
        #     * directory [String] - The path to the directory
        #     * files [String] - The size of the files in bytes
        #     * bytes [String] - The size of the directory in bytes

        def du(path)
          path_guard(path)
          request(:du,
                  path: format_path(path),
                  method: 'GET',
                  expects: 200,
                  parser: Fog::Parsers::Storage::Akamai::Du.new)
        end
      end

      class Mock
        def du(path)
          path_guard(path)

          key = format_path(path)
          directory = data[key]

          if directory
            Excon::Response.new(status: 200, body: { directory: key, files: directory[:files].count.to_s, bytes: directory[:directories].count.to_s })
          else
            fail(Excon::Errors::NotFound, '404 Not Found')
          end
        end
      end
    end
  end
end
