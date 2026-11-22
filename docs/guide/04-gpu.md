# Part 4: Let the graphics card do the work

Most of the time Jellyfin sends the file as it is (**direct play**) and the PC does almost nothing. When a device can't play the file, or the connection is too slow, Jellyfin converts it on the fly (**transcoding**). An NVIDIA card does that far better than the CPU.

No NVIDIA card? Skip this part. The CPU will convert, just slower. Intel and AMD graphics also work in Jellyfin, but this guide only covers NVIDIA.

## 4.1 Update the driver

**What:** install the current NVIDIA driver.

**Why:** Jellyfin needs a recent driver for NVENC, the card's video encoder.

**How:** NVIDIA app > Drivers > Check for updates, or download it from [nvidia.com](https://www.nvidia.com/drivers).

**Check:** Task Manager > Performance > your NVIDIA GPU shows the new driver version.

## 4.2 Turn on NVENC

**What:** tell Jellyfin to use the NVIDIA card.

**How:** Dashboard > Playback > **Transcoding**:

1. Hardware acceleration: **Nvidia NVENC**.
2. Enable hardware decoding for: tick the formats your card supports. Look up your card in [NVIDIA's support table](https://developer.nvidia.com/video-encode-and-decode-gpu-support-matrix-new). Most cards from GTX 10 onward handle H264, HEVC, HEVC 10bit, VP9 and MPEG2. Only RTX 30 and newer handle AV1.
3. Enable hardware encoding: **on**. Leave the rest as it is.
4. **Save** at the bottom.

**Check:** the page saves without an error. The real check is next.

## 4.3 Prove it uses the card

**What:** force a conversion and watch the GPU.

**Why:** a wrong setting falls back to the CPU without telling you.

**How:**

1. Play a movie in a browser on the PC.
2. Gear icon > **Quality** > the lowest option.
3. Task Manager > Performance > the NVIDIA GPU. Switch one of the small graphs to **Video Encode**.
4. When done, set Quality back to **Auto**.

**Check:** player ⋯ > **Playback Info** says **Transcoding**, the Video Encode graph rises, and the CPU stays low.

Next: [Part 5: Watch at home](05-watch-at-home.md)
