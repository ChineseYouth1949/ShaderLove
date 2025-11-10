#pragma once

#include "Base/DXSample.h"

#include <chrono>

using namespace DirectX;

class Graphics : public DXSample {
 public:
  Graphics(UINT width, UINT height, std::wstring name);

  void OnInit() override;
  void OnUpdate() override;
  void OnRender() override;
  void OnDestroy() override;

  void OnKeyDown(UINT8 key) override;
  void OnKeyUp(UINT8 key) override;

  void OnMouseMove(UINT x, UINT y) override;
  void OnLeftButtonDown(UINT x, UINT y) override;
  void OnLeftButtonUp(UINT x, UINT y) override;
  void OnRightButtonDown(UINT x, UINT y) override;
  void OnRightButtonUp(UINT x, UINT y) override;
  void OnMouseWheel(INT d) override;

 private:
  static const UINT FrameCount = 2;

  struct Vertex {
    XMFLOAT3 position;
  };

  CD3DX12_VIEWPORT m_viewport;
  CD3DX12_RECT m_scissorRect;
  ComPtr<IDXGISwapChain3> m_swapChain;
  ComPtr<ID3D12Device> m_device;
  ComPtr<ID3D12Resource> m_renderTargets[FrameCount];
  ComPtr<ID3D12CommandAllocator> m_commandAllocator;
  ComPtr<ID3D12CommandQueue> m_commandQueue;
  ComPtr<ID3D12RootSignature> m_rootSignature;
  ComPtr<ID3D12DescriptorHeap> m_rtvHeap;
  ComPtr<ID3D12PipelineState> m_pipelineState;
  ComPtr<ID3D12GraphicsCommandList> m_commandList;
  UINT m_rtvDescriptorSize;

  ComPtr<ID3D12Resource> m_vertexBuffer;
  D3D12_VERTEX_BUFFER_VIEW m_vertexBufferView;

  UINT m_frameIndex;
  HANDLE m_fenceEvent;
  ComPtr<ID3D12Fence> m_fence;
  UINT64 m_fenceValue;

  void LoadCoreInterface();
  void WaitForPreviousFrame();

  void CreatePSO();
  void CreateVertexBuffer();

  // Here are the core differences between this example and HelloTriangle.
  struct SceneConstantBuffer {
    XMFLOAT2 resolution;
    float time;
    float scale = 1.0f;
    int timeBackColor = 0;
    int timeLoveColor = 0;
    float padding[58];  // 244 bytes (61 floats × 4 bytes each)
  };
  static_assert((sizeof(SceneConstantBuffer) % 256) == 0, "Constant Buffer size must be 256-byte aligned");

  ComPtr<ID3D12DescriptorHeap> m_cbvHeap;
  ComPtr<ID3D12Resource> m_constantBuffer;
  SceneConstantBuffer m_constantBufferData;
  UINT8* m_pCbvDataBegin;

  std::chrono::time_point<std::chrono::high_resolution_clock> m_beginTime;

  void LoadPipeline();
  void PopulateCommandList();

  void CreateRootSignature();
  void CreateConstantBuffer();
};