/*
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *
 */

#include <quic/dsr/backend/test/TestUtils.h>
#include <quic/tools/tperf/TperfDSRSender.h>

namespace quic {

TperfDSRSender::TperfDSRSender(uint64_t blockSize, folly::AsyncUDPSocket& sock)
    : blockSize_(blockSize), sock_(sock) {}

bool TperfDSRSender::addSendInstruction(const SendInstruction& instruction) {
  instructions_.push_back(instruction);
  return true;
}

bool TperfDSRSender::flush() {
  RequestGroup prs;
  for (const auto& instruction : instructions_) {
    prs.push_back(test::sendInstructionToPacketizationRequest(instruction));
  }
  auto written =
      writePacketsGroup(sock_, prs, [=](const PacketizationRequest& req) {
        auto buf = folly::IOBuf::createChain(req.len, blockSize_);
        auto curBuf = buf.get();
        do {
          curBuf->append(curBuf->capacity());
          curBuf = curBuf->next();
        } while (curBuf != buf.get());
        return buf;
      });
  instructions_.clear();
  return written > 0;
}

void TperfDSRSender::release() {}
} // namespace quic
