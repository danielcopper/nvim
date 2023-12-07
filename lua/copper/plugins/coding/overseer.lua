return {
  "stevearc/overseer.nvim",
  cmd = { "CompilerOpen", "CompilerToggleResults" }, -- So it triggers when using compiler.lua
  opts = {
    -- Tasks are disposed 5 minutes after running to free resources.
    -- If you need to close a task inmediatelly:
    -- press ENTER in the output menu on the task you wanna close.
    task_list = {   -- this refers to the window that shows the result
      direction = "bottom",
      min_height = 25,
      max_height = 25,
      default_detail = 1,
    },
  },
}
