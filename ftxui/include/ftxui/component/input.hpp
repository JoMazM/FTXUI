#ifndef FTXUI_COMPONENT_INPUT_H_
#define FTXUI_COMPONENT_INPUT_H_

#include "ftxui/component/component.hpp"
#include <functional>

namespace ftxui {

class Input : public Component {
 public:
  // Constructor.
  Input() = default;
  ~Input() override = default;

  // State.
  std::wstring content;
  std::wstring placeholder;

  // State update callback.
  std::function<void()> on_change = [](){};
  std::function<void()> on_enter = [](){};

  // Component implementation.
  Element Render() override;
  bool OnEvent(Event) override;

 private:
  int cursor_position = 0;
};

}  // namespace ftxui

#endif /* end of include guard: FTXUI_COMPONENT_INPUT_H_ */
