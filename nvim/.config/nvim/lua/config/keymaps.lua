-- File: ~/.config/nvim/lua/config/keymaps.lua
-- This file defines custom keybindings.

-- This function compiles a C++ file and places the executable in an 'output'
-- subdirectory relative to the source file's location.
local function compile_and_run_cpp()
  -- Save the current file to ensure we're compiling the latest version.
  vim.cmd("silent! w")

  local current_file = vim.fn.expand("%:p") -- Get the full path of the current file
  -- Check if the current file is actually a C++ file.
  if not current_file:match("%.cpp$") then
    vim.notify("Not a C++ file!", vim.log.levels.ERROR, { title = "Run Error" })
    return
  end

  -- Get the directory where the current file is located.
  -- '%:p:h' is a vim command that means: 'full path' (:p) and then 'head' (:h) which is the directory.
  local file_dir = vim.fn.expand("%:p:h")

  -- Get just the filename without extension (e.g., "csesWeirdAlgorithm")
  -- '%:t' gets the 'tail' (filename only), ':r' gets the root (no extension)
  local base_name = vim.fn.fnamemodify(vim.fn.expand("%:t"), ":r")

  -- Define the output directory path *relative to the source file*.
  local output_dir = file_dir .. "/output"
  local executable_path = output_dir .. "/" .. base_name

  -- Check if the 'output' directory exists in the file's folder, and create it if it doesn't.
  local stat = vim.loop.fs_stat(output_dir)
  if not stat then
    -- The directory does not exist, so we create it.
    local perms = tonumber("755", 8) -- Correct way to specify octal permissions
    vim.loop.fs_mkdir(output_dir, perms)
    vim.notify("Created '" .. output_dir .. "' directory.", vim.log.levels.INFO, { title = "Project Setup" })
  elseif stat.type ~= "directory" then
    -- A file named 'output' exists where the directory should be.
    vim.notify(
      "Error: '" .. output_dir .. "' exists but is not a directory!",
      vim.log.levels.ERROR,
      { title = "Run Error" }
    )
    return
  end

  -- Construct the compile and run command using the new relative paths.
  local command =
    string.format("g++ -g -std=c++17 -Wall %s -o %s && %s", current_file, executable_path, executable_path)

  -- Open a terminal in a horizontal split and execute the command.
  vim.cmd("sp | term " .. command)
end

-- Now, we map the <C-Enter> key to our function in Normal mode.
vim.keymap.set(
  "n",
  "<C-Enter>",
  compile_and_run_cpp,
  { noremap = true, silent = true, desc = "Compile & Run C++ File" }
)
