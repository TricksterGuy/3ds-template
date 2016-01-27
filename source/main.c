#include <3ds.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <time.h>

int main(int argc, char **argv)
{
    srand(time(NULL));
	gfxInitDefault();

	// Initialize console on top screen. Using NULL as the second argument tells the console library to use the internal console structure as current one
	consoleInit(GFX_TOP, NULL);

	printf("Test Code::Blocks project!");

	printf("\x1b[20;15HPress Start to exit.");

	// We don't need double buffering in this example. In this way we can draw our image only once on screen.
	gfxSetDoubleBuffering(GFX_BOTTOM, false);

	// Get the bottom screen's frame buffer
	u16 width, height;
	u8* fb = gfxGetFramebuffer(GFX_BOTTOM, GFX_LEFT, &width, &height);

    // Randomize
    for (int i = 0; i < width * height * 3; i++)
        fb[i] = rand() & 0xFF;

	// Main loop
	while (aptMainLoop())
	{
		// Scan all the inputs. This should be done once for each frame
		hidScanInput();

		// hidKeysDown returns information about which buttons have been just pressed (and they weren't in the previous frame)
		u32 kDown = hidKeysDown();

        // break in order to return to hbmenu
		if (kDown & KEY_START)
            break;

		// Flush and swap framebuffers
		gfxFlushBuffers();
		gfxSwapBuffers();

		//Wait for VBlank
		gspWaitForVBlank();
	}

	// Exit services
	gfxExit();
	return 0;
}
