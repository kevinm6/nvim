-------------------------------------
-- File         : colorscheme.lua
-- Description  : initialize and set colorscheme
-- Author       : Kevin
-- Last Modified: 11 Aug 2022, 10:33
-------------------------------------

-- Unloading if packages are already loaded
package.loaded["colors.knvim"] = nil
package.loaded["colors.knvim.palette"] = nil
package.loaded["colors.knvim.config"] = nil

-- initialization
require "colors.knvim".load()
