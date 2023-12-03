# PULL PR!
usethis::pr_fetch(90)

# Then,
usethis::pr_push()

# Then,
usethis::pr_finish()

# Check spelling
# usethis::use_spell_check()
spelling::spell_check_package()

devtools::check(remote = TRUE)

devtools::check_mac_release()

devtools::check_win_devel()

devtools::check_win_release()

# check on other distributions
# _rhub
rhub::check_for_cran()

# devtools::check_rhub()

# Check reverse dependencies

# Update NEWS
# Bump version manually and add list of changes

# Add comments for CRAN
# usethis::use_cran_comments(open = rlang::is_interactive())

# Upgrade version number
# usethis::use_version(which = c("patch", "minor", "major", "dev")[1])

# Check that it works without suggested dependencies...
devtools::check(env_vars = c(`_R_CHECK_DEPENDS_ONLY_` = TRUE))

# Verify you're ready for release, and release
devtools::release()

# Post release!
usethis::use_github_release()
