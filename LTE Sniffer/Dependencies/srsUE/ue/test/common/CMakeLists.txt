# Copyright 2015 Software Radio Systems Limited
#
# This file is part of srsUE
#
# srsUE is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of
# the License, or (at your option) any later version.
#
# srsUE is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# A copy of the GNU Affero General Public License can be found in
# the LICENSE file in the top-level directory of this distribution
# and at http://www.gnu.org/licenses/.
#

#######################################################################
# LOGGER TEST
#######################################################################
add_executable(logger_test logger_test.cc)
target_link_libraries(logger_test srsue_common ${Boost_LIBRARIES})
add_test(logger_test logger_test)

add_executable(msg_queue_test msg_queue_test.cc)
target_link_libraries(msg_queue_test srsue_common ${Boost_LIBRARIES})
add_test(msg_queue_test msg_queue_test)

add_executable(log_filter_test log_filter_test.cc)
target_link_libraries(log_filter_test srsue_common ${Boost_LIBRARIES})

add_executable(timeout_test timeout_test.cc)
target_link_libraries(timeout_test srsue_common ${Boost_LIBRARIES})
