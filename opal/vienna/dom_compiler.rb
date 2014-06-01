require 'vienna/bindings'

module Vienna
  class DOMCompiler
    def initialize(view, context)
      %x{
        self.view = view
        self.node = view.element[0];
        self.context = context;
        self.$compile_tree(self.node);
      }
    end

    def compile_tree(node)
      %x{
        while (node) {
          self.$compile_node(node);
          node = self.$next_node(node);
        }
      }
    end

    def next_node(current)
      %x{
        var children = current.childNodes;

        if (children && children.length && !((' ' + children[0].className + ' ').indexOf('vienna-view') > -1)) {
          return children[0];
        }

        var sibling = current.nextSibling;

        if (self.node === current) {
          return;
        }
        else if (sibling) {
          return sibling;
        }

        var next_parent = current;

        while (next_parent = next_parent.parentNode) {
          var parent_sibling = next_parent.nextSibling;

          if (self.node === next_parent) {
            return;
          }
          else if (parent_sibling) {
            return parent_sibling;
          }
        }

        return;
      }
    end

    def compile_node(node)
      %x{
        if (node.attributes && node.getAttribute) {
          var attributes = node.attributes, bindings = [];

          for (var idx = 0, len = attributes.length; idx < len; idx++) {
            var attribute = attributes[idx], name = attribute.nodeName;

            if (!name || name.substr(0, 5) !== 'data-') {
              continue;
            }

            name = name.substr(5);
            bindings.push([name, attribute.value]);

            var binding_class;

            if (name === 'bind') {
              if (node.tagName.toLowerCase() === 'input') {
                binding_class = Opal.Vienna.InputBinding;
              }
              else {
                binding_class = Opal.Vienna.ValueBinding;
              }
            }
            else if (name === 'bind-if') {
              binding_class = Opal.Vienna.ShowIfBinding;
            }
            else if (name === 'bind-unless') {
              binding_class = Opal.Vienna.HideIfBinding;
            }
            else if (name === 'bind-each') {
              binding_class = Opal.Vienna.EachBinding;
            }
            else if (name === 'action') {
              binding_class = Opal.Vienna.ActionBinding;
            }
            else if (name === 'view') {
              binding_class = Opal.Vienna.ViewBinding;
            }
            else {
              // stop a binding class appearing on next iteration
              binding_class = null;
            }

            if (binding_class) {
              binding_class.$new(self.view, self.context, node, attribute.value);
            }
            else {
              // console.log("unknown binding class for '" + name + "'");
            }
          }
        }
      }
    end
  end
end
