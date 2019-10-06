#pragma once
#include <memory>
#include <ostream>
#include <variant>
#include <vector>

class TreeNode {
public:
    virtual ~TreeNode() = default;
    virtual std::ostream& Print(std::ostream& stream) const = 0;
};

using TreeNodePtr = std::shared_ptr<TreeNode>;

class StringNode : public TreeNode {
public:
    explicit StringNode(const std::string& value) : value_(value) {
    }

    std::ostream& Print(std::ostream& stream) const override {
        stream << value_;
        return stream;
    }

private:
    std::string value_;
};

class SeqNode : public TreeNode {
public:
    explicit SeqNode(std::initializer_list<TreeNodePtr> list) : seq_(list) {}

    std::ostream& Print(std::ostream& stream) const override {
        stream << "{ ";
        for (const auto& val : seq_) {
            val->Print(stream) << " ";
        }
        stream << "}";
        return stream;
    }

private:
    std::vector<TreeNodePtr> seq_;
};

inline TreeNodePtr MakeValue(const std::string& value) {
    return std::make_shared<StringNode>(value);
}

inline TreeNodePtr MakeSeq(std::initializer_list<TreeNodePtr> list) {
    return std::make_shared<SeqNode>(list);
}
