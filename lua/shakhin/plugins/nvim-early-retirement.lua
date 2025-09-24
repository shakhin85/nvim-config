return {
  "chrisgrieser/nvim-early-retirement",
  config = function()
    require("early-retirement").setup({
      retirementAgeMins = 20,
      ignoreAltFile = true,
      minimumBufferNum = 4,
      ignoreUnsavedChangesBufs = true,
      ignoreSpecialBuftypes = true,
      ignoreVisibleBufs = true,
      ignoreUnloadedBufs = true,
      notificationOnAutoClose = true,
    })
  end,
}