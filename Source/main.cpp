#include "Core/Graphics.h"

int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE, LPSTR, int nCmdShow) {
  Graphics gc(1280, 720, L"DirectShadertoy");
  return Win32Application::Run(&gc, hInstance, nCmdShow);
}